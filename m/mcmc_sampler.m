%Copyright © 2018, Sampsa Pursiainen
function [z,rec_source] = mcmc_sampler(void)

[s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}'));
n_interp = length(s_ind_1(:));

beta = evalin('base','zef.inv_beta');
theta0 = evalin('base','zef.inv_theta0');
eta = beta - 1.5;
kappa = beta + 1.5;
std_lhood = evalin('base','zef.inv_likelihood_std');
sampling_freq = evalin('base','zef.inv_sampling_frequency');
high_pass = evalin('base','zef.inv_low_cut_frequency');
low_pass = evalin('base','zef.inv_high_cut_frequency');
roi_mode = evalin('base','zef.inv_roi_mode');
roi_threshold = evalin('base','zef.inv_roi_threshold');
roi_sphere = evalin('base', 'zef.inv_roi_sphere');
rec_source = evalin('base', 'zef.inv_rec_source');
n_sampler = evalin('base','zef.inv_n_sampler'); 
n_burn_in = evalin('base','zef.inv_n_burn_in');

number_of_frames = evalin('base','zef.number_of_frames');
time_step = evalin('base','zef.inv_time_3');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');
source_positions = evalin('base','zef.source_positions');

if source_direction_mode == 2

[s_ind_3] = evalin('base','zef.source_interpolation_ind{3}'); 

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
for k = 1 : 9   
switch k
    case 1
        var_0 = 'zef.d1_on';
        var_1 = 'zef.d1_sigma';
        var_2 = 'zef.d1_priority';
        var_3 = 'zef.d1_visible';
    color_str = evalin('base','zef.d1_color');
     case 2
        var_0 = 'zef.d2_on';
        var_1 = 'zef.d2_sigma';   
        var_2 = 'zef.d2_priority';
        var_3 = 'zef.d2_visible';
        color_str = evalin('base','zef.d2_color');
     case 3
        var_0 = 'zef.d3_on';
        var_1 = 'zef.d3_sigma';   
        var_2 = 'zef.d3_priority';
        var_3 = 'zef.d3_visible';
        color_str = evalin('base','zef.d3_color');
     case 4
        var_0 = 'zef.d4_on';
        var_1 = 'zef.d4_sigma';   
        var_2 = 'zef.d4_priority';
        var_3 = 'zef.d4_visible';
        color_str = evalin('base','zef.d4_color');
    case 5
        var_0 = 'zef.w_on';
        var_1 = 'zef.w_sigma';    
        var_2 = 'zef.w_priority';
        var_3 = 'zef.w_visible';
        color_str = evalin('base','zef.w_color');
    case 6
        var_0 = 'zef.g_on';
        var_1 = 'zef.g_sigma';
        var_2 = 'zef.g_priority';
        var_3 = 'zef.g_visible';
        color_str = evalin('base','zef.g_color');
    case 7
        var_0 = 'zef.c_on';
        var_1 = 'zef.c_sigma';
        var_2 = 'zef.c_priority';
        var_3 = 'zef.c_visible';
        color_str = evalin('base','zef.c_color');
     case 8
        var_0 = 'zef.sk_on';
        var_1 = 'zef.sk_sigma';
        var_2 = 'zef.sk_priority';
        var_3 = 'zef.sk_visible';
        color_str = evalin('base','zef.sk_color');
     case 9
        var_0 = 'zef.sc_on';
        var_1 = 'zef.sc_sigma';
        var_2 = 'zef.sc_priority';
        var_3 = 'zef.sc_visible';
        color_str = evalin('base','zef.sc_color');
     end
on_val = evalin('base',var_0);      
sigma_val = evalin('base',var_1);  
priority_val = evalin('base',var_2);
visible_val = evalin('base',var_3);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
color_cell{i} = color_str;
visible_vec(i,1) = i*visible_val;
if k == 6;
    aux_brain_ind = i;
end
if k == 5;
    aux_wm_ind = i;
end
end
end

aux_p = evalin('base',['zef.reuna_p{' int2str(aux_brain_ind) '}']);
aux_t = evalin('base',['zef.reuna_t{' int2str(aux_brain_ind) '}']);

n_vec_aux = cross(aux_p(aux_t(:,2),:)' - aux_p(aux_t(:,1),:)', aux_p(aux_t(:,3),:)' - aux_p(aux_t(:,1),:)')';
n_vec_aux = n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);

n_vec_aux(:,1) = smooth_field(aux_t, n_vec_aux(:,1), size(aux_p(:,1),1),7);
n_vec_aux(:,2) = smooth_field(aux_t, n_vec_aux(:,2), size(aux_p(:,1),1),7);
n_vec_aux(:,3) = smooth_field(aux_t, n_vec_aux(:,3), size(aux_p(:,1),1),7);

n_vec_aux = - n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);

source_directions = n_vec_aux(s_ind_3,:);

end

source_positions = source_positions(s_ind_1,:);

if source_direction_mode == 3
source_directions = source_directions(s_ind_1,:);
end

if source_direction_mode == 1  || source_direction_mode == 2
s_ind_1 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1];
end
if  source_direction_mode == 3
s_ind_2 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1];
end

s_ind_1 = s_ind_1(:);

L = evalin('base','zef.L');
L = L(:,s_ind_1);

if source_direction_mode == 2

L_1 = L(:,1:n_interp);
L_2 = L(:,n_interp+1:2*n_interp);
L_3 = L(:,2*n_interp+1:3*n_interp);
s_1 = source_directions(:,1)';
s_2 = source_directions(:,2)';
s_3 = source_directions(:,3)';
ones_vec = ones(size(L,1),1);
L = L_1.*s_1(ones_vec,:) + L_2.*s_2(ones_vec,:) + L_3.*s_3(ones_vec,:);
clear L_1 L_2 L_3 s_1 s_2 s_3;

end

%if evalin('base','zef.use_gpu') == 1
%L = gpuArray(L);
%end
%L_aux = L;
S_mat = std_lhood^2*eye(size(L,1));
%if evalin('base','zef.use_gpu') == 1
%S_mat = gpuArray(S_mat);
%end

if number_of_frames > 1
z = cell(number_of_frames,1);
else
number_of_frames = 1;
end

tic;
for f_ind = 1 : number_of_frames
time_val = toc; 
if f_ind > 1; 
date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400));
end;

if iscell(evalin('base','zef.measurements'));
f = evalin('base',['zef.measurements{' int2str(evalin('base','zef.inv_data_segment')) '}']);
else
f = evalin('base','zef.measurements');
end

data_norm = 1;
if evalin('base','zef.normalize_data')==1;
data_norm = max(abs(f(:)).^2); 
%std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==2;
data_norm = max((sum(abs(f).^2)));
%std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==3;
data_norm = sum((sum(abs(f).^2)))/size(f,2);
%std_lhood = std_lhood^2;
end;
f = f/data_norm;

if source_direction_mode == 1
z_aux = zeros(size(L,2),1); 
end
if source_direction_mode == 2 || source_direction_mode == 3
z_aux = zeros(3*size(L,2),1);
end
z_vec = zeros(size(L,2),1); 
%theta = theta0*ones(length(z_vec),1);
%aux_norm = (sum(L.^2))';
%aux_norm = aux_norm./max(aux_norm(:));
%theta = theta0*aux_norm;

if size(f,2) > 1  
if evalin('base','zef.inv_time_2') >=0 0 && evalin('base','zef.inv_time_1') >= 0 & 1 + sampling_freq*evalin('base','zef.inv_time_1') <= size(f,2);
f = f(:, max(1, 1 + floor(sampling_freq*evalin('base','zef.inv_time_1')+sampling_freq*(f_ind - 1)*evalin('base','zef.inv_time_3'))) : min(size(f,2), 1 + floor(sampling_freq*(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2'))+sampling_freq*(f_ind - 1)*evalin('base','zef.inv_time_3'))));
end
end
if size(f,2) > 1
t = [1:size(f,2)];
gaussian_window_param = 20;
gaussian_window = exp(-((t-(length(t)/2)).^2./(2*(length(t)/gaussian_window_param)^2)))/(sqrt(2*pi)*(length(t)/gaussian_window_param))*length(t);
gaussian_window = gaussian_window(ones(size(f,1),1),:);
fft_f = fft(f.*gaussian_window,[],2);
clear gaussian_window;
f = fft_f.*conj(fft_f)/size(f,2);
clear fft_f;
f = f(:,1:floor(size(f,2)/2));
low_pass_ind = 1 + floor((low_pass/(sampling_freq/2))*size(f,2));
high_pass_ind = 1 + floor((high_pass/(sampling_freq/2))*size(f,2));
low_pass_ind = min(low_pass_ind, size(f,2));
high_pass_ind = min(high_pass_ind, size(f,2));
if high_pass > 0; 
   high_pass_ind = max(2,high_pass_ind);
else
   high_pass_ind = max(1,high_pass_ind);
end
low_pass_ind = max(high_pass_ind,low_pass_ind);
f = sum(f(:,high_pass_ind:low_pass_ind),2)/(low_pass_ind - high_pass_ind + 1);
end
%if f_ind == 1
%h = waitbar(0,['IAS MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
%end
n_ias_map_iter = evalin('base','zef.inv_n_map_iterations');

%if evalin('base','zef.use_gpu') == 1
%f = gpuArray(f);
%end

gibbs_sampler;

if source_direction_mode == 2 || source_direction_mode == 3
z_vec = [z_vec.*source_directions(:,1); z_vec.*source_directions(:,2);  z_vec.*source_directions(:,3)];
end

if source_direction_mode == 1 || source_direction_mode == 2
z_aux(s_ind_1) = z_vec;
end
if source_direction_mode == 3
z_aux(s_ind_2) = z_vec;
end

if number_of_frames > 1;
z{f_ind} = z_aux;
else
z = z_aux;
end;
end;
if number_of_frames > 1;
aux_norm_vec = 0;
for f_ind = 1 : number_of_frames;
aux_norm_vec = max(sqrt(sum(reshape(z{f_ind}, 3, length(z{f_ind})/3).^2)),aux_norm_vec);
end;
for f_ind = 1 : number_of_frames;
z{f_ind} = z{f_ind}./max(aux_norm_vec);
end;
else
aux_norm_vec = sqrt(sum(reshape(z, 3, length(z)/3).^2)); 
z = z./max(aux_norm_vec);
end;
%close(h);

z = z./max(abs(z(:)));

end