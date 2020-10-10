% Example_3_ECGC: Mesh the greater US East Coast and Gulf of Mexico region
% with a high resolution inset around New York

clearvars; clc;

if ismac    % On Mac
    basedir = '/Users/yulong/GitHub/';
    addpath([basedir,'OceanMesh2D/']);
    addpath([basedir,'/map_lab/m_map/']);
    addpath([basedir,'OceanMesh2D/datasets/']);
    addpath([basedir,'OceanMesh2D/utilities/']);
    addpath([basedir,'map_lab_features/coastlines/gshhg-shp-2.3.7/GSHHS_shp/f']);
    addpath([basedir,'map_lab_features/coastlines/gshhg-shp-2.3.7/GSHHS_shp/l']);
end

%% STEP 1: set mesh extents and set parameters for mesh. 
%% The greater US East Coast and Gulf of Mexico region

x_bond_01 = [139.142156 139.142156	139.144724 139.152351 139.164815 ...
    139.18178	139.202839	139.227552	139.25548	139.286203 ...
    139.31934	139.354542	139.391505	139.429958	139.469663 ...
    139.510408	139.552007	139.594291	139.637105	139.680308 ...
    139.723765	139.767348	139.810932	139.854389	139.897592 ...
    139.940406	139.98269	140.024289	140.065034	140.104739 ...
    140.143192	140.180155	140.215357	140.248493	140.279217 ...
    140.307145	140.331858	140.352917	140.369882	140.382346 ...
    140.389973	140.392541	140.392541	139.142156];
y_bond_01 = [35.859592	 35.225989	35.182486  35.139579  35.097818 ...
    35.057672  35.019512  34.983607  34.95014  34.919216 ...
    34.890891  34.865177  34.842062  34.82152  34.803513 ...
    34.788004  34.774954  34.764328  34.756096 34.750234 ...
    34.746724  34.745556  34.746724  34.750234 34.756096 ...
    34.764328  34.774954  34.788004  34.803513 34.82152 ...
    34.842062  34.865177  34.890891  34.919216 34.95014	...
    34.983607  35.019512  35.057672  35.097818 35.139579 ...
    35.182486  35.225989  35.859592	 35.859592];
bbox_01       = [x_bond_01',y_bond_01'];
min_el_01    = 9e2;  	   % minimum resolution in meters.
max_el_01    = 20e3; 	   % maximum resolution in meters. 
wl_01        = 30;         % 60 elements resolve M2 wavelength.
dt_01        = 0;          % Automatically set timestep based on nearshore res
grade_01     = 0.25;       % mesh grade in decimal percent. 
R_01         = 3; 		   % Number of elements to resolve feature.
slp_01       = 50;         % 2*pi/number of elements to resolve slope
fl_01        = -50;        % use filter equal to Rossby radius divided by 50
  
%% STEP 2: specify geographical datasets and process the geographical data
%% to be used later with other OceanMesh classes...
dem_01       = 'depth_0270-03.nc';
% dem       = 'depth_0810-01.nc';
coastline_01 = 'C23-06_TOKYOBAY';
% coastline = 'GSHHS_f_L1';
gdat_01 = geodata('shp',coastline_01,...
                  'dem',dem_01,...
                  'h0',min_el_01,...
                  'bbox',bbox_01);
            
%% STEP 3: create an edge function class
fh_01 = edgefx('geodata',gdat_01,...
             'fs',R_01,'wl',wl_01,...
             'slp',slp_01,'fl',fl_01,...
             'max_el',max_el_01,...
             'dt',dt_01,'g',grade_01);
          
%% Repeat STEPS 1-3 for a high resolution domain for High Res New York Part
min_el_02    = 6e2;  		% minimum resolution in meters.
max_el_02    = 9e2; 		% maximum resolution in meters. 
wl_02        = 10;
dt_02        = 0;
grade_02     = 0.35;       % mesh grade in decimal percent. 
R_02         = 5; 		   % Number of elements to resolve feature.
slp_02       = 30;         % 2*pi/number of elements to resolve slope
fl_02        = -50;

coastline_02 = 'C23-06_TOKYOBAY_OUTER'; 
dem_02       = 'depth_0090-06+07.nc';

x_bond_02 = [140.1708 140.1727 139.6147 139.6147 139.6478 ...
             139.6481 139.6814 139.7542 139.7632 139.8618 ...
             140.1708];
y_bond_02 = [35.2441 35.8491 35.8451 35.2763 35.2288 ...
             35.1567 35.1464 34.9783 34.9657 34.9657 ...
             35.2441];
bbox_02      = [x_bond_02',y_bond_02'];

gdat_02 = geodata('shp',coastline_02,...
                  'dem',dem_02,...
                  'h0',min_el_02,...
                  'bbox',bbox_02);
              
fh_02 = edgefx('geodata',gdat_02,...
               'fs',R_02,'wl',wl_02,...
               'slp',slp_02,'fl',fl_02,...
               'max_el',max_el_02,...
               'dt',dt_02,'g',grade_02);
           
%% Repeat STEPS 1-3 for a high resolution domain for High Res New York Part
min_el_03    = 5e1;  		% minimum resolution in meters.
max_el_03    = 9e2; 		% maximum resolution in meters. 
wl_03        = 10;
dt_03        = 0;
grade_03     = 0.25;       % mesh grade in decimal percent. 
R_03         = 3; 		   % Number of elements to resolve feature.
slp_03       = 50;         % 2*pi/number of elements to resolve slope
fl_03        = -10;

coastline_03 = 'C23-06_TOKYOBAY_INNER'; 
dem_03       = 'depth_0010-16+17+18+19+20+21+22+23.nc';

x_bond_03 = [139.6186 139.7978 140.1562 140.1590 139.9604 ...
             139.9070 139.8663 139.7839 139.7461 139.6341 ...
             139.6186 139.6186];
y_bond_03 = [35.5562 35.7823 35.7849 35.4909 35.2584 ...
             35.2584 35.3126 35.3127 35.2562 35.2562 ...
             35.2763 35.5562];
bbox_03      = [x_bond_03',y_bond_03'];

gdat_03 = geodata('shp',coastline_03,...
                  'dem',dem_03,...
                  'h0',min_el_03,...
                  'bbox',bbox_03);
              
fh_03 = edgefx('geodata',gdat_03,...
               'fs',R_03,'wl',wl_03,...
               'slp',slp_03,'fl',fl_03,...
               'max_el',max_el_03,...
               'dt',dt_03,'g',grade_03);

%% STEP 4: Pass your edgefx class object along with some meshing options 
%% and build the mesh...
mshopts = meshgen('ef',{fh_01 fh_02 fh_03},'bou',{gdat_01 gdat_02 gdat_03},...
                  'plot_on',1,'proj','lam', 'itmax',200);
mshopts = mshopts.build; 

%% Plot and save the msh class object/write to fort.14
m = mshopts.grd; % get out the msh object
m = interp(m,{gdat_01 gdat_02 gdat_03},'mindepth',0.05); % interpolate bathy to the mesh with minimum depth of 1 m
m = make_bc(m,'auto',gdat_01);               % make the nodestring boundary conditions
plot(m,'bd',1); % plot on native projection with nodestrings
plot(m,'b',1); % plot bathy on native projection
plot(m,'reso',1,[],[],[10, 0 10e3]) % plot the resolution
save('case_01_tokyobay.mat','m'); write(m,'case_01_tokyobay');
