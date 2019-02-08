% Example_3_ECGC: Mesh the greater US East Coast and Gulf of Mexico region
% with a high resolution inset around New York
clearvars; clc;
addpath(genpath('utilities/'));
addpath(genpath('datasets/'));
addpath(genpath('m_map/'));

%% STEP 1: set mesh extents and set parameters for mesh. 
%% The greater US East Coast and Gulf of Mexico region
bbox = [-71.6 42.7; -64 30; -80 24; -85 38; -71.6 42.7]; %polygon boubox
min_el    = 1e3;  		        % minimum resolution in meters.
max_el    = 50e3; 		        % maximum resolution in meters. 
wl        = 30;                 % 60 elements resolve M2 wavelength.
dt        = 0;                  % Try to ensure mesh is stable at a 2 s timestep.
grade     = 0.35;               % mesh grade in decimal percent. 
R         = 3; 			        % Number of elements to resolve feature.
  
%% STEP 2: specify geographical datasets and process the geographical data
%% to be used later with other OceanMesh classes...
dem       = 'topo15_compressed.nc';
coastline = 'GSHHS_f_L1';
gdat1 = geodata('shp',coastline,'dem',dem,'h0',min_el,...
                'bbox',bbox);
            
%% STEP 3: create an edge function class
fh1 = edgefx('geodata',gdat1,...
             'fs',R,'wl',wl,'max_el',max_el,...
             'dt',dt,'g',grade);
          
%% Repeat STEPS 1-3 for a high resolution domain for High Res New York Part
min_el    = 30;  		% minimum resolution in meters.
max_el    = 1e3; 		% maximum resolution in meters. 
max_el_ns = 240;  		% maximum resolution nearshore.

coastline = 'PostSandyNCEI'; 
dem       = 'PostSandyNCEI.nc';

% Bounding box is automatically taken from the DEM file
gdat2 = geodata('shp',coastline,'dem',dem,'h0',min_el);

fh2 = edgefx('geodata',gdat2,'fs',R,'wl',wl,...
             'max_el',max_el,'max_el_ns',max_el_ns,...
             'dt',dt,'g',grade);
                
%% STEP 4: Pass your edgefx class object along with some meshing options 
%% and build the mesh...
mshopts = meshgen('ef',{fh1 fh2},'bou',{gdat1 gdat2},...
                  'plot_on',1,'proj','lam');
mshopts = mshopts.build; 

%% Plot and save the msh class object/write to fort.14
m = mshopts.grd; % get out the msh object
m = interp(m,{gdat1 gdat2}); m.b = max(m.b,1); % interpolate bathy to the mesh
m = makens(m,'auto',gdat1); % make the nodestring boundary conditions
plot(m,'bd',1); % plot on native projection with nodestrings
plot(m,'b',1); % plot bathy on native projection
save('ECGC_w_NYHR.mat','m'); write(m,'ECGC_w_NYHR');
