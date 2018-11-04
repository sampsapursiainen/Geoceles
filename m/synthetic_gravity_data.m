%Copyright © 2018, Sampsa Pursiainen
%[zef.sigma,zef.brain_ind] = zef_sigma([]);
tic;

if zef.source_direction_mode == 1
zef.lf_param.direction_mode = 'cartesian';
end
if zef.source_direction_mode == 2
zef.lf_param.direction_mode = 'normal';
end
if zef.source_direction_mode == 3
zef.lf_param.direction_mode = 'face_based';
end
if isfield(zef,'preconditioner')
if zef.preconditioner == 1
zef.lf_param.precond = 'cholinc';
elseif zef.preconditioner == 2
zef.lf_param.precond = 'ssor';
end
end
if isfield(zef,'preconditioner_tolerance')
zef.lf_param.cholinc_tol = zef.preconditioner_tolerance;
else
zef.lf_param.cholinc_tol = 0.001;
end
if isfield(zef,'solver_tolerance')
zef.lf_param.pcg_tol = zef.solver_tolerance;
else
zef.lf_param.pcg_tol = 1e-8;
end
zef.aux_vec = [];
if isempty(zef.source_ind) || not(zef.n_sources == zef.n_sources_old) || not(zef.wm_sources == zef.wm_sources_old) 
if isempty(zef.non_source_ind)
zef.aux_vec = zef.brain_ind;
else
zef.aux_vec = setdiff(zef.brain_ind,zef.non_source_ind);
end
zef.aux_vec = zef.aux_vec(randperm(length(zef.aux_vec)));
zef.n_sources_old = zef.n_sources;
zef.wm_sources_old = zef.wm_sources;
zef.source_ind = zef.aux_vec(1:min(zef.n_sources,length(zef.aux_vec)));
zef.n_sources_mod = 0;
end
zef.sensors_aux = zef.sensors;
zef.nodes_aux = zef.nodes;%/1000;
%if ismember(zef.imaging_method, [1 3 4]) & size(zef.sensors,2) == 3
%zef.sensors_aux = zef.sensors_attached_volume(:,1:3)/1000;
%elseif zef.imaging_method == 2
zef.sensors_aux(:,1:3) = zef.sensors_aux(:,1:3);%/1000;
%else
%zef.sensors_aux = zef.sensors_attached_volume;
%end

zef.lf_param.dipole_mode = 1;

if zef.imaging_method == 4
if size(zef.sensors,2) == 6
zef.lf_param.impedances = zef.sensors(:,6);
end
[zef.measurements] = compute_gravity_data(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
end

zef = rmfield(zef,{'nodes_aux','sensors_aux','aux_vec'});


