% Example_2_NY: Mesh the New York region in high resolution
clearvars; clc;

if ismac    % On Mac
    basedir = '/Users/yulong/GitHub/';
addpath([basedir,'OceanMesh2D/']);
addpath([basedir,'/map_lab/m_map/']);
addpath([basedir,'OceanMesh2D/datasets/']);
addpath([basedir,'OceanMesh2D/utilities/']);
addpath([basedir,'grds/gis_new/TKBAY/']);
addpath([basedir,'map_lab_features/coastlines/gshhg-shp-2.3.7/GSHHS_shp/f']);
addpath([basedir,'map_lab_features/coastlines/gshhg-shp-2.3.7/GSHHS_shp/l']);
elseif isunix       % Unix?
addpath([basedir,'OceanMesh2D/']);
addpath([basedir,'/map_lab/m_map/']);
addpath([basedir,'OceanMesh2D/datasets/']);
addpath([basedir,'OceanMesh2D/utilities/']);
addpath([basedir,'grds/gis_new/TKBAY/']);
addpath([basedir,'map_lab_features/coastlines/gshhg-shp-2.3.7/GSHHS_shp/f']);
addpath([basedir,'map_lab_features/coastlines/gshhg-shp-2.3.7/GSHHS_shp/l']);
elseif ispc     % Or Windows?
    basedir = 'C:/Users/Yulong WANG/Documents/GitHub/';   
addpath([basedir,'OceanMesh2D/']);
addpath([basedir,'/map_lab/m_map/']);
addpath([basedir,'OceanMesh2D/datasets/']);
addpath([basedir,'OceanMesh2D/utilities/']);
addpath([basedir,'grds/gis_new/TKBAY/']);
addpath([basedir,'map_lab_features/coastlines/gshhg-shp-2.3.7/GSHHS_shp/f']);
addpath([basedir,'map_lab_features/coastlines/gshhg-shp-2.3.7/GSHHS_shp/l']);
end

%% STEP 1: Set mesh extents and set parameters for mesh.
x_bond = [140.3657568 140.3714000 140.3714000 139.1426000 139.1426000 139.1728161 139.1783783 139.183938 139.190291	139.1984605	139.2066266	139.2147892	139.2250097	139.2356498	139.2462858	139.2577393	139.2706831	139.2836222	139.2965568	139.3113451	139.3263821	139.3414143	139.3572015	139.374099	139.3909919	139.4078801	139.4262609	139.4447492	139.4632333	139.482314	139.5021085	139.5218995	139.5416869	139.5624594	139.5832485	139.6040349	139.6251636	139.646627	139.6680888	139.6895598	139.7113638	139.7331673	139.7549704	139.7767748	139.7985811	139.8203881	139.8421681	139.8636384	139.8851104	139.9065843	139.9276501	139.9484533	139.9692593	139.9899355	140.0097457	140.0295596	140.0493772	140.0683352	140.0868477	140.1053646	140.1235926	140.140514	140.1574402	140.174371	140.1899819	140.2050514	140.2201256	140.2347127	140.2476875	140.2606669	140.2736509	140.284884	140.2955624	140.3062448	140.3162266	140.3244328	140.3326424	140.3408553	140.346956	140.3525596	140.3581655	140.3628653	140.3657568];
y_bond = [35.14311934 35.17890000 35.80000000 35.80000000 35.14500000 35.10662737 35.08918083 35.07173391 35.05450271	35.03776501	35.02102661	35.00428752	34.98835518	34.97258773	34.95681919	34.94148284	34.9269332	34.91238201	34.89782928	34.8845509	34.87144454	34.85833616	34.84589675	34.83443988	34.82298051	34.81151864	34.80176228	34.79213067	34.78249611	34.77376405	34.76611031	34.75845324	34.75079286	34.74519597	34.73963568	34.73407176	34.72961491	34.72623798	34.72285723	34.71954318	34.71840219	34.71725729	34.71610847	34.71621674	34.71732558	34.71843054	34.71971561	34.72306103	34.7264027	34.72974062	34.73440787	34.73993438	34.74545737	34.75125595	34.75888136	34.7665036	34.77412267	34.78304697	34.79264986	34.80224998	34.81218349	34.82361744	34.83504909	34.84647842	34.85908059	34.87216548	34.88524855	34.89866896	34.9132028	34.92773529	34.94226641	34.95772598	34.97348063	34.98923436	35.00526464	35.02199477	35.03872433	35.05545334	35.07276004	35.09020299	35.10764567	35.12523561	35.14311934];
bbox = [x_bond',y_bond'];
% bbox = [139.35 140.21;		% lon_min lon_max
%         34.80 35.75]; 		% lat_min lat_max
min_el    = 50;  		% minimum resolution in meters.
max_el    = 5000; 		% maximum resolution in meters. 
max_el_ns = 100;        % maximum resolution nearshore in meters.
grade     = 0.35; 		% mesh grade in decimal percent.
R         = 10;    		% number of elements to resolve feature width.
dt        = 10;         % Encourage mesh to be stable at a 2 s timestep
%% STEP 2: Specify geographical datasets and process the geographical data 
%% to be used later with other OceanMesh classes.
coastline = 'TKBAY.shp';
dem       = 'TKBAY.nc';
gdat = geodata('shp',coastline,...
               'dem',dem,...
               'bbox',bbox,...
               'h0',min_el); 
%% STEP 3: Create an edge function class.
fh = edgefx('geodata',gdat,...
            'fs',R,'max_el_ns',max_el_ns,...
            'max_el',max_el,'dt',dt,'g',grade);
%% STEP 4: Pass your edgefx class object along with some meshing options and
% build the mesh...
mshopts = meshgen('ef',fh,'bou',gdat,'proj','utm','plot_on',1);
mshopts = mshopts.build; 
%% STEP 5: Plot it and write a triangulation fort.14 compliant file to disk.
% Get out the msh class and put on bathy and nodestrings
m = mshopts.grd;
m = interp(m,gdat,'mindepth',1); % interpolate bathy to the mesh with minimum depth of 1 m
m = make_bc(m,'auto',gdat,'depth',5);  % make the nodestring boundary conditions 
                                 % with min depth of 5 m on open boundary
plot(m,'bd'); plot(m,'blog');    % plot triangulation, and bathy on log scale
% write(m,'NY_HR');                % write to ADCIRC compliant ascii file
