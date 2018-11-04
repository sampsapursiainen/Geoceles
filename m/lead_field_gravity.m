%Copyright © 2018, Sampsa Pursiainen
function [L_eit,  bg_data, dipole_locations, dipole_directions] = lead_field_eeg_fem(nodes,elements,sigma,electrodes,varargin) 
% function [L_eeg, source_locations, source_directions] = lead_field_eeg_fem(nodes,elements,sigma,electrodes,brain_ind,source_ind,additional_options)
% 
% Input:
% ------
% - nodes              = N x 3
% - elements           = M x 4
% - sigma              = M x 1 (or M x 6, one row: sigma_11 sigma_22 sigma_33 sigma_12 sigma_13 sigma_23)
% - electrodes         = L x 3
% - brain_ind          = P x 1 (The set of elements that potentially contain source currents, by default contains all elements)
% - source_ind         = R x 1 (The set of elements that are allowed to contain source currents, a subset of brain_ind, by default equal to brain_ind)
% - additional_options = Struct, see below
% 
% Fields of additional_options: 
% -----------------------------
%
% - additional_options.direction_mode: Source directions; Values: 'mesh based' (default) or 'Cartesian' (optional).
%   Note: If Cartesian directions are used, the columns of the lead field matrix correspond 
%   to directions x y z x y z x y z ..., respectively.
% - additional_options.precond: Preconditioner type; Values: 'cholinc' (Incomplete Cholesky, default) or 'ssor' (SSOR, optional)
% - additional_options.cholinc_tol: Tolerance of the Incomplete Cholesky; Values: Numeric (default is 0.001) or '0' (complete Cholesky)
% - additional_options.pcg_tol: Tolerance of the PCG iteration; Values: Numeric (default is 1e-6) 
% - additional_options.maxit: Maximum number of PCG iteration steps; Values: Numeric (default is 3*floor(sqrt(N)))
% - additional_options.dipole_mode: Element-wise source direction mode; Values: '1' (direction of the dipole moment, default) or '2' (line segment between nodes 4 and 5 with the numbering given in Pursiainen et al 2011)
% - additional_options.permutation: Permutation of the linear system; Values: 'symamd' (default), 'symmmd' (optional), 'symrcm' (optional), or 'none' (optional) 
%
% Output:
% -------
% - L_eeg              = L x K 
% - source_locations   = K x 3 (or K/3 x 3, if Cartesian are used)
% - source_directions  = K x 3 
%

N = size(nodes,1);
source_model = evalin('base','zef.source_model');

if iscell(elements)
        tetrahedra = elements{1};
        prisms = [];
        K2 = size(tetrahedra,1);
        waitbar_length = 4;
        if length(elements)>1
        prisms = elements{2};
        waitbar_length = 10;
        end
    else
        tetrahedra = elements;
        prisms = [];
        K2 = size(tetrahedra,1);
        waitbar_length = 4;
    end
    clear elements;
            
    if iscell(sigma)
        sigma{1} = sigma{1}';
        if size(sigma{1},1) == 1   
        sigma_tetrahedra = [repmat(sigma{1},3,1) ; zeros(3,size(sigma{1},2))];
        else
        sigma_tetrahedra = sigma{1};    
        end
        sigma_prisms = [];
        if length(sigma)>1
        sigma{2} = sigma{2}';    
        if size(sigma{2},1) == 1   
        sigma_prisms = [repmat(sigma{2},3,1) ; zeros(3,size(sigma{2},2))];
        else
        sigma_prisms = sigma{2};
        end
        end
    else
        sigma = sigma';
        if size(sigma,1) == 1   
        sigma_tetrahedra = [repmat(sigma,3,1) ; zeros(3,size(sigma,2))];
        else
        sigma_tetrahedra = sigma;
        end
        sigma_prisms = [];
    end
    clear elements;

    tol_val = 1e-6;
    m_max = 3*floor(sqrt(N));
    precond = 'cholinc';
    permutation = 'symamd';
    direction_mode = 'mesh based';
    dipole_mode = 1;
    brain_ind = [1:size(tetrahedra,1)]'; 
    source_ind = [1:size(tetrahedra,1)]';   
    cholinc_tol = 1e-3;
    if size(electrodes,2) == 4
    electrode_model = 'CEM';    
    L = max(electrodes(:,1));
    ele_ind = electrodes;
    impedance_vec = ones(max(electrodes(:,1)),1);
    impedance_inf = 1;
    else 
    electrode_model = 'PEM';
    L = size(electrodes,1);
    ele_ind = zeros(L,1);
    for i = 1 : L
    [min_val, min_ind] = min(sum((repmat(electrodes(i,:),N,1)' - nodes').^2));   
    ele_ind(i) = min_ind; 
    end      
    end
    
    n_varargin = length(varargin);
    if n_varargin >= 1
    if not(isstruct(varargin{1}))
    brain_ind = varargin{1};
    end
    end   
    if n_varargin >= 2
    if not(isstruct(varargin{2}))
    source_ind = varargin{2};
    end
    end
    if n_varargin >= 1
    if isstruct(varargin{n_varargin})
    if isfield(varargin{n_varargin},'pcg_tol');
        tol_val = varargin{n_varargin}.pcg_tol;
    end
    if  isfield(varargin{n_varargin},'maxit');
        m_max = varargin{n_varargin}.maxit;
    end
    if  isfield(varargin{n_varargin},'precond');
        precond = varargin{n_varargin}.precond;
    end
    if isfield(varargin{n_varargin},'direction_mode');
    direction_mode = varargin{n_varargin}.direction_mode;
    end
    if isfield(varargin{n_varargin},'dipole_mode');
    dipole_mode = varargin{n_varargin}.dipole_mode;
    end
    if isfield(varargin{n_varargin},'impedances') & size(electrodes,2) == 4;
    if length(varargin{n_varargin}.impedances)==1;
    impedance_vec = varargin{n_varargin}.impedances*ones(max(electrodes(:,1)),1);
    impedance_inf = 0;
    else
    impedance_vec = varargin{n_varargin}.impedances;   
    impedance_inf = 0;
    end
    end
    if isfield(varargin{n_varargin},'cholinc_tol')
    cholinc_tol = varargin{n_varargin}.cholinc_tol;
    end    
    if isfield(varargin{n_varargin},'permutation')
    permutation = varargin{n_varargin}.permutation;
    end  
    end
    end
    K = length(brain_ind);
    K3 = length(source_ind);
    clear electrodes;


Aux_mat = [nodes(tetrahedra(:,1),:)'; nodes(tetrahedra(:,2),:)'; nodes(tetrahedra(:,3),:)'] - repmat(nodes(tetrahedra(:,4),:)',3,1); 
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
tilavuus = abs(Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
                - Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
                + Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;

c_tet = 0.25*(nodes(tetrahedra(:,1),:) + nodes(tetrahedra(:,2),:) + nodes(tetrahedra(:,3),:) + nodes(tetrahedra(:,4),:));         

[eit_ind, eit_count] = make_gravity_dec(nodes,tetrahedra,brain_ind,source_ind);


h = waitbar(0,'Interpolation.');

L_eit = zeros(3*L, K3);
%tilavuus_vec_aux = zeros(1, K3);
sensors = evalin('base','zef.sensors(:,1:3)');
bg_data = zeros(3*L,1);

 for i = 1 : K

r_aux_vec = tilavuus(brain_ind(i))./sum((repmat(c_tet(brain_ind(i),:),L,1) - sensors).^3,2);
aux_vec = (repmat(c_tet(brain_ind(i),:),L,1) - sensors).*repmat(r_aux_vec,1,3);
bg_data = bg_data + sigma_tetrahedra(1,brain_ind(i))*aux_vec(:);
L_eit(:,eit_ind(i)) = L_eit(:,eit_ind(i)) + aux_vec(:);

%tilavuus_vec_aux(eit_ind(i)) = tilavuus_vec_aux(eit_ind(i)) + tilavuus(brain_ind(i))*eit_count(eit_ind(i));

if mod(i,floor(K/50))==0 
time_val = toc;
waitbar(i/K,h,['Interpolation. Ready approx: ' datestr(datevec(now+(K/i - 1)*time_val/86400)) '.']);
end
 end


close(h);
 
L_eit = (6.67408E-11)*L_eit;
bg_data = (6.67408E-11)*bg_data;

%for i = length(source_ind)
%L_eit_aux(:,i) = L_eit_aux(:,i); %/tilavuus_vec_aux(i); 
%end
 
 dipole_locations = (nodes(tetrahedra(source_ind,1),:) + nodes(tetrahedra(source_ind,2),:) + nodes(tetrahedra(source_ind,3),:)+ nodes(tetrahedra(source_ind,4),:))/4;
 dipole_directions = ones(size(dipole_locations));


