%Copyright © 2018, Sampsa Pursiainen
function [void] = plot_meshes(void);

void = [];

if evalin('base','zef.visualization_type') == 3
s_i_ind = evalin('base','zef.source_interpolation_ind{2}');
s_i_ind_2 =  evalin('base','zef.source_interpolation_ind{1}');
max_abs_reconstruction = 0;
min_rec = Inf;
max_rec = -Inf;
if iscell(evalin('base','zef.reconstruction'))
length_reconstruction_cell = length(evalin('base','zef.reconstruction'));
frame_start = evalin('base','zef.frame_start');
frame_stop = evalin('base','zef.frame_stop');
frame_step = evalin('base','zef.frame_step');
if frame_start == 0
frame_start = 1;
end
if frame_stop == 0
frame_stop = length_reconstruction_cell;
end
frame_start = max(frame_start,1);
frame_start = min(length_reconstruction_cell,frame_start);
frame_stop = max(frame_stop,1);
frame_stop = min(length_reconstruction_cell,frame_stop);
number_of_frames = length([frame_start : frame_step : frame_stop]);
for f_ind = frame_start : frame_step : frame_stop
reconstruction = evalin('base',['zef.reconstruction{' int2str(f_ind) '}']);
reconstruction = reconstruction(:);  
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
if ismember(evalin('base','zef.reconstruction_type'), 6)
reconstruction = (1/sqrt(3))*sum(reconstruction)';
else    
reconstruction = sqrt(sum(reconstruction.^2))';
end
reconstruction = sum(reconstruction(s_i_ind_2),2)/4;
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
end
if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
min_rec = 10*log10(max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
max_rec = 10*log10(max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
min_rec = (max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
max_rec = (max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
min_rec = sqrt(max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
max_rec = sqrt(max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
end
end
else
frame_start = 1;
frame_stop = 1;
frame_step = 1;
number_of_frames = 1;    
reconstruction = evalin('base','zef.reconstruction');
reconstruction = reconstruction(:);  
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
if ismember(evalin('base','zef.reconstruction_type'), 6)
reconstruction = (1/sqrt(3))*sum(reconstruction)';
else    
reconstruction = sqrt(sum(reconstruction.^2))';
end
reconstruction = sum(reconstruction(s_i_ind_2),2)/4;
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
min_rec = 10*log10(max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
max_rec = 10*log10(max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
min_rec = (max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
max_rec = (max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
min_rec = sqrt(max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
max_rec = sqrt(max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
end   
end 
end
end
    
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


axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));
set(evalin('base','zef.h_axes1'),'YDir','normal');
h_axes_text = findobj(evalin('base','zef.h_geoceles'),'tag','image_details');
if not(isempty(h_axes_text))
delete(h_axes_text); 
h_axes_text = [];
end
h_colorbar = findobj(evalin('base','zef.h_geoceles'),'tag','Colorbar');
if not(isempty(h_colorbar))
colorbar(h_colorbar,'delete'); 
end
hold on;
light('Position',[0 0 1],'Style','infinite');
light('Position',[0 0 -1],'Style','infinite');
sensors = evalin('base','zef.sensors');
reuna_p = evalin('base','zef.reuna_p');
reuna_t = evalin('base','zef.reuna_t');  
if evalin('base','zef.cp_on') || evalin('base','zef.cp2_on') || evalin('base','zef.cp3_on')
    for i = 1 : length(reuna_t)
triangle_c{i} = (1/3)*(reuna_p{i}(reuna_t{i}(:,1),:) + reuna_p{i}(reuna_t{i}(:,2),:) + reuna_p{i}(reuna_t{i}(:,3),:));
    end
end

aux_ind_1 = [];
aux_ind_2 = cell(1,length(reuna_t));

if evalin('base','zef.cp_on')
cp_a = evalin('base','zef.cp_a');
cp_b = evalin('base','zef.cp_b');
cp_c = evalin('base','zef.cp_c');
cp_d = evalin('base','zef.cp_d');
% if cp_a ~= 0 | cp_b ~=0    
% light('Position',[-cp_a -cp_b -cp_b],'Style','infinite');
% end
if not(isempty(aux_ind_1))
aux_ind_1 = intersect(aux_ind_1,find(sum(sensors(:,1:3).*repmat([cp_a cp_b cp_c],size(sensors,1),1),2) >= cp_d));
else
aux_ind_1 = find(sum(sensors(:,1:3).*repmat([cp_a cp_b cp_c],size(sensors,1),1),2) >= cp_d);
end
for i = 1 : length(reuna_t)
    if not(isempty(aux_ind_2{i}))
aux_ind_2{i} = intersect(aux_ind_2{i},find(sum(triangle_c{i}.*repmat([cp_a cp_b cp_c],size(triangle_c{i},1),1),2) >= cp_d));
else
aux_ind_2{i} = find(sum(triangle_c{i}.*repmat([cp_a cp_b cp_c],size(triangle_c{i},1),1),2) >= cp_d);
    end
end    
end


if evalin('base','zef.cp2_on')
cp2_a = evalin('base','zef.cp2_a');
cp2_b = evalin('base','zef.cp2_b');
cp2_c = evalin('base','zef.cp2_c');
cp2_d = evalin('base','zef.cp2_d');
% if cp2_a ~= 0 | cp2_b ~=0    
% light('Position',[-cp2_a -cp2_b -cp2_b],'Style','infinite');
% end
if not(isempty(aux_ind_1))
aux_ind_1 = intersect(aux_ind_1,find(sum(sensors(:,1:3).*repmat([cp2_a cp2_b cp2_c],size(sensors,1),1),2) >= cp2_d));
else
aux_ind_1 = find(sum(sensors(:,1:3).*repmat([cp2_a cp2_b cp2_c],size(sensors,1),1),2) >= cp2_d);
end
for i = 1 : length(reuna_t)
    if not(isempty(aux_ind_2{i}))
aux_ind_2{i} = intersect(aux_ind_2{i},find(sum(triangle_c{i}.*repmat([cp2_a cp2_b cp2_c],size(triangle_c{i},1),1),2) >= cp2_d));
else
aux_ind_2{i} = find(sum(triangle_c{i}.*repmat([cp2_a cp2_b cp2_c],size(triangle_c{i},1),1),2) >= cp2_d);
    end
end    
end

if evalin('base','zef.cp3_on')
cp3_a = evalin('base','zef.cp3_a');
cp3_b = evalin('base','zef.cp3_b');
cp3_c = evalin('base','zef.cp3_c');
cp3_d = evalin('base','zef.cp3_d');
% if cp3_a ~= 0 | cp3_b ~=0    
% light('Position',[-cp3_a -cp3_b -cp3_b],'Style','infinite');
% end
if not(isempty(aux_ind_1))
aux_ind_1 = intersect(aux_ind_1,find(sum(sensors(:,1:3).*repmat([cp3_a cp3_b cp3_c],size(sensors,1),1),2) >= cp3_d));
else
aux_ind_1 = find(sum(sensors(:,1:3).*repmat([cp3_a cp3_b cp3_c],size(sensors,1),1),2) >= cp3_d);
end
for i = 1 : length(reuna_t)
if not(isempty(aux_ind_2{i}))
aux_ind_2{i} = intersect(aux_ind_2{i},find(sum(triangle_c{i}.*repmat([cp3_a cp3_b cp3_c],size(triangle_c{i},1),1),2) >= cp3_d));
else
aux_ind_2{i} = find(sum(triangle_c{i}.*repmat([cp3_a cp3_b cp3_c],size(triangle_c{i},1),1),2) >= cp3_d);
end
end    
end


if evalin('base','zef.cp_on') || evalin('base','zef.cp2_on') || evalin('base','zef.cp3_on')
if evalin('base','zef.cp_mode') == 1
sensors = sensors(aux_ind_1,:);
elseif evalin('base','zef.cp_mode') == 2
aux_ind_1 = setdiff([1:size(sensors,1)]',aux_ind_1);
sensors = sensors(aux_ind_1,:);   
end
for i = 1 : length(reuna_t)
if evalin('base','zef.cp_mode') == 1
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
if evalin('base','zef.visualization_type') == 3
if i == aux_brain_ind;
s_i_ind = s_i_ind(aux_ind_2{i},:);
end;
end
elseif evalin('base','zef.cp_mode') == 2
aux_ind_2{i} = setdiff([1:size(reuna_t{i},1)]',aux_ind_2{i});
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);   
if evalin('base','zef.visualization_type') == 3
if i == aux_brain_ind;
s_i_ind = s_i_ind(aux_ind_2{i},:);
end;
end
elseif evalin('base','zef.cp_mode') == 3
if i == aux_brain_ind
aux_ind_2{i} = reuna_t{i};
else
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
end
elseif evalin('base','zef.cp_mode') == 4
if i == aux_brain_ind
aux_ind_2{i} = reuna_t{i};
else  
aux_ind_2{i} = setdiff([1:size(reuna_t{i},1)]',aux_ind_2{i});
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:); 
end
end
end
end

aux_ind_1 = [];
aux_ind_2 = cell(1,length(reuna_t));
triangle_c = cell(1,length(reuna_t));

[X_s, Y_s, Z_s] = sphere(20);

if ismember(evalin('base','zef.imaging_method'), [1 4 5])  & size(sensors,2) == 6 
    electrode_model = 2;
elseif ismember(evalin('base','zef.imaging_method'), [1 4 5])
    electrode_model = 1;
else
    electrode_model = 0;
end

if evalin('base','zef.attach_electrodes') & electrode_model == 1
for i = 1 : size(sensors,1)
[min_val, min_ind] = min(sqrt(sum((reuna_p{end} - repmat(sensors(i,1:3),size(reuna_p{end},1),1)).^2,2)));
sensors(i,1:3) = reuna_p{end}(min_ind,:);
end
end

if evalin('base','zef.attach_electrodes') & electrode_model == 2
   center_points_aux = (1/3)*(reuna_p{end}(reuna_t{end}(:,1),:) + ...
                       reuna_p{end}(reuna_t{end}(:,2),:) + ...
                       reuna_p{end}(reuna_t{end}(:,3),:));
for i = 1 : size(sensors,1)
[min_val, min_ind] = min(sqrt(sum((reuna_p{end} - repmat(sensors(i,1:3),size(reuna_p{end},1),1)).^2,2)));
sensors(i,1:3) = reuna_p{end}(min_ind,:);
end
 sensors_aux = []; 
 for i = 1 : size(sensors,1)
 [dist_val] = (sqrt(sum((center_points_aux - repmat(sensors(i,1:3),size(center_points_aux,1),1)).^2,2)));
 dist_ind = find(dist_val <= sensors(i,4) & dist_val >= sensors(i,5)); 
 sensors_aux = [sensors_aux ; i*ones(length(dist_ind),1) reuna_t{end}(dist_ind,:)];
 end
 sensors = sensors_aux;
end


if evalin('base','zef.s_visible')
if electrode_model == 1 | not(ismember(evalin('base','zef.imaging_method'),[1,4,5]))
sphere_scale = 0.025*max(sqrt(sum(sensors(:,1:3).^2,2)));     
X_s = sphere_scale*X_s;
Y_s = sphere_scale*Y_s;
Z_s = sphere_scale*Z_s;
for i = 1 : size(sensors,1)
h = surf(sensors(i,1) + X_s, sensors(i,2) + Y_s, sensors(i,3) + Z_s);
set(h,'facecolor',evalin('base','zef.s_color'));
set(h,'edgecolor','none'); 
set(h,'specularstrength',0.6);
set(h,'diffusestrength',0.6);
set(h,'ambientstrength',0.8);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
end
elseif electrode_model == 2  
h = trisurf(sensors(:,2:4),reuna_p{end}(:,1),reuna_p{end}(:,2),reuna_p{end}(:,3));
set(h,'facecolor',evalin('base','zef.s_color'));
set(h,'edgecolor',evalin('base','zef.s_color')); 
set(h,'specularstrength',0.6);
set(h,'diffusestrength',0.6);
set(h,'ambientstrength',0.8);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
set(h,'edgealpha',evalin('base','zef.layer_transparency'));
end

if ismember(evalin('base','zef.imaging_method'),[2 3])
sensors(:,4:6) = sensors(:,4:6)./repmat(sqrt(sum(sensors(:,4:6).^2,2)),1,3);
h=coneplot(sensors(:,1) + 4.5*sensors(:,4),sensors(:,2) + 4.5*sensors(:,5),sensors(:,3) + 4.5*sensors(:,6),8*sensors(:,4),8*sensors(:,5),8*sensors(:,6),0,'nointerp');
set(h,'facecolor',evalin('base','zef.s_color'));
set(h,'edgecolor','none'); 
set(h,'specularstrength',0.6);
set(h,'diffusestrength',0.6);
set(h,'ambientstrength',0.8);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
if size(sensors,2) == 9
sensors(:,7:9) = sensors(:,7:9)./repmat(sqrt(sum(sensors(:,7:9).^2,2)),1,3);
h=coneplot(sensors(:,1) + 4.5*sensors(:,7),sensors(:,2) + 4.5*sensors(:,8),sensors(:,3) + 4.5*sensors(:,9),8*sensors(:,7),8*sensors(:,8),8*sensors(:,9),0,'nointerp');
set(h,'facecolor', 0.9*[1 1 1]);
set(h,'edgecolor','none'); 
set(h,'specularstrength',0.6);
set(h,'diffusestrength',0.6);
set(h,'ambientstrength',0.8);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
end
end
end


if evalin('base','zef.visualization_type') == 3


i = 0;

for k = 1 : 9
switch k
    case 1
        on_val = evalin('base','zef.d1_on');
        visible_val = evalin('base','zef.d1_visible');
        color_str =  evalin('base','zef.d1_color');
    case 2
        on_val = evalin('base','zef.d2_on');
        visible_val = evalin('base','zef.d2_visible');
        color_str = evalin('base','zef.d2_color');
    case 3
        on_val = evalin('base','zef.d3_on');
        visible_val = evalin('base','zef.d3_visible');
        color_str = evalin('base','zef.d3_color');
    case 4
        on_val = evalin('base','zef.d4_on');
        visible_val = evalin('base','zef.d4_visible');
        color_str = evalin('base','zef.d4_color');
    case 5
        on_val = evalin('base','zef.w_on');
        visible_val = evalin('base','zef.w_visible');
        color_str = evalin('base','zef.w_color');
    case 6
        on_val = evalin('base','zef.g_on');
        visible_val = evalin('base','zef.g_visible');
        color_str = evalin('base','zef.g_color');
    case 7
        on_val = evalin('base','zef.c_on');
        visible_val = evalin('base','zef.c_visible');
        color_str = evalin('base','zef.c_color');
    case 8
        on_val = evalin('base','zef.sk_on');
        visible_val = evalin('base','zef.sk_visible');
        color_str = evalin('base','zef.sk_color');
    case 9
        on_val = evalin('base','zef.sc_on');
        visible_val = evalin('base','zef.sc_visible');
        color_str = evalin('base','zef.sc_color');
    end
if on_val  
i = i + 1;    
if visible_val
if  i == aux_brain_ind    
    
if  iscell(evalin('base','zef.reconstruction')) 
h_waitbar = waitbar(1/number_of_frames,['Frame ' int2str(1) ' of ' int2str(number_of_frames) '.']);    
set(h_waitbar,'handlevisibility','off');
end    
    
colormap_size = 4096;
if evalin('base','zef.inv_colormap') == 1
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
colormap_vec_aux = [([20*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1)]); ([15*[1: c_aux_1] 15*[c_aux_2-c_aux_1:-1:1] zeros(1,colormap_size-c_aux_2)]) ; ([zeros(1,c_aux_1) 6*[1:c_aux_2-c_aux_1] 6*[colormap_size-c_aux_2:-1:1]]);([zeros(1,c_aux_2) 7.5*[1:colormap_size-c_aux_2]])];
colormap_vec = zeros(3,size(colormap_vec_aux,2));
colormap_vec = colormap_vec + 0.52*[50*colormap_vec_aux(1,:) ; 50*colormap_vec_aux(1,:) ; 50*colormap_vec_aux(1,:)];
colormap_vec = colormap_vec + 0.5*[85*colormap_vec_aux(3,:) ; 197*colormap_vec_aux(3,:) ; 217*colormap_vec_aux(3,:)];
colormap_vec = colormap_vec + 0.1*[2*colormap_vec_aux(2,:) ; 118*colormap_vec_aux(2,:) ; 132*colormap_vec_aux(2,:)];
colormap_vec = colormap_vec + [203*colormap_vec_aux(4,:) ; 203*colormap_vec_aux(4,:) ; 100*colormap_vec_aux(4,:)];
clear colormap_vec_aux;
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = colormap_vec(:,1:3);
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 2
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
colormap_vec = zeros(3,colormap_size);
colormap_vec(1,:) =10*([colormap_size:-1:1]/colormap_size);
colormap_vec(2,:) = [10*( (3/2)*[c_aux_2:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_2)];
colormap_vec(3,:) = [10*((3)*[c_aux_1:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_1)];  
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
colormap_vec = colormap_vec(:,1:3);
colormap_vec = colormap_vec + repmat(0.2*([colormap_size:-1:1]'/colormap_size),1,3);
colormap_vec = colormap_vec/max(colormap_vec(:));
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 3
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
colormap_vec = zeros(3,colormap_size);
colormap_vec(2,:) = 10*([colormap_size:-1:1]/colormap_size);
colormap_vec(1,:) = [10*(3/2)*[c_aux_2:-1:1]/colormap_size zeros(1,colormap_size-c_aux_2)];
colormap_vec(3,:) = [10*(3*[c_aux_1:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_1)];
%colormap_vec([1 3 2],:) = 0.75*colormap_vec([1 3 2],:) + 0.25*colormap_vec([1 2 3],:);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
colormap_vec = colormap_vec(:,1:3);
colormap_vec = colormap_vec + repmat(0.2*([colormap_size:-1:1]'/colormap_size),1,3);
colormap_vec = colormap_vec/max(colormap_vec(:));
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 4
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
colormap_vec = zeros(3,colormap_size);
colormap_vec(3,:) = 10*([colormap_size:-1:1]/colormap_size);
colormap_vec(2,:) = [10*(3/2)*[c_aux_2:-1:1]/colormap_size zeros(1,colormap_size-c_aux_2)];
colormap_vec(1,:) = [10*(3*[c_aux_1:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_1)];
%colormap_vec([1 3 2],:) = 0.75*colormap_vec([1 3 2],:) + 0.25*colormap_vec([1 2 3],:);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
colormap_vec = colormap_vec(:,1:3);
colormap_vec = colormap_vec + repmat(0.2*([colormap_size:-1:1]'/colormap_size),1,3);
colormap_vec = colormap_vec/max(colormap_vec(:));
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 5
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
colormap_vec = [([20*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1)]); ([15*[1: c_aux_1] 15*[c_aux_2-c_aux_1:-1:1] zeros(1,colormap_size-c_aux_2)]) ; ([zeros(1,c_aux_1) 6*[1:c_aux_2-c_aux_1] 6*[colormap_size-c_aux_2:-1:1]]);([zeros(1,c_aux_2) 7.5*[1:colormap_size-c_aux_2]])];
colormap_vec([1 2],:) = colormap_vec([2 1],:);
colormap_vec(1,:) = colormap_vec(1,:) + colormap_vec(2,:);
colormap_vec(3,:) = colormap_vec(4,:) + colormap_vec(3,:);
colormap_vec(2,:) = colormap_vec(4,:) + colormap_vec(2,:);
colormap_vec(1,:) = colormap_vec(4,:) + colormap_vec(1,:);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
colormap_vec = colormap_vec(:,1:3);
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 6
c_aux_1 = floor(colormap_size/3);
c_aux_2 = floor(2*colormap_size/3);
c_aux_3 = floor(colormap_size/2);
colormap_vec = [([20*[c_aux_3:-1:1] zeros(1,colormap_size-c_aux_3)]); ([15*[1: c_aux_1] 15*[c_aux_2-c_aux_1:-1:1] zeros(1,colormap_size-c_aux_2)]) ; ([zeros(1,c_aux_1) 7*[1:c_aux_2-c_aux_1] 7*[colormap_size-c_aux_2:-1:1]]);([zeros(1,c_aux_2) 10.5*[1:colormap_size-c_aux_2]])];
colormap_vec(3,:) = colormap_vec(4,:) + colormap_vec(3,:);
colormap_vec(2,:) = colormap_vec(4,:) + colormap_vec(2,:);
colormap_vec(1,:) = colormap_vec(4,:) + colormap_vec(1,:);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
colormap_vec = colormap_vec(:,1:3);
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 7
c_aux_1 = floor(colormap_size/2);    
colormap_vec = [10*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1); 3*[1: c_aux_1] 3*[colormap_size-c_aux_1:-1:1]; zeros(1,c_aux_1) 3.8*[1:colormap_size-c_aux_1]];
colormap_vec([1 2],:) = colormap_vec([2 1],:);
colormap_vec(1,:) = colormap_vec(1,:) + colormap_vec(2,:);
colormap_vec(1,:) = colormap_vec(3,:) + colormap_vec(1,:);
colormap_vec(2,:) = colormap_vec(3,:) + colormap_vec(2,:);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 8
c_aux_1 = floor(colormap_size/2);    
colormap_vec = [10*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1); 3*[1: c_aux_1] 3*[colormap_size-c_aux_1:-1:1]; zeros(1,c_aux_1) 3.8*[1:colormap_size-c_aux_1]];
colormap_vec([2 3],:) = colormap_vec([3 2],:);
colormap_vec(1,:) = colormap_vec(2,:) + colormap_vec(1,:);
colormap_vec(3,:) = colormap_vec(2,:) + colormap_vec(3,:);
colormap_vec = colormap_vec+100;
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 9
c_aux_1 = floor(colormap_size/2);    
colormap_vec = [10*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1); 2*[1: c_aux_1] 2*[colormap_size-c_aux_1:-1:1]; zeros(1,c_aux_1) 3.8*[1:colormap_size-c_aux_1]];
colormap_vec(1,:) = colormap_vec(3,:) + colormap_vec(1,:);
colormap_vec(2,:) = colormap_vec(3,:) + colormap_vec(2,:);
colormap_vec = colormap_vec+100;
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 10
c_aux_1 = floor(colormap_size/2);    
colormap_vec = [10*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1); 8*[1: c_aux_1] 8*[colormap_size-c_aux_1:-1:1]; zeros(1,c_aux_1) 5*[1:colormap_size-c_aux_1]];
colormap_vec = colormap_vec+100;
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 11
colormap_vec = [(colormap_size/5)^3 + colormap_size^2*[1 : colormap_size] ; (colormap_size/2)^3 + ((colormap_size)/2)*[1:colormap_size].^2 ; ...
    (0.7*colormap_size)^3+(0.5*colormap_size)^2*[1:colormap_size]];
colormap_vec = colormap_vec'/max(colormap_vec(:));
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
elseif evalin('base','zef.inv_colormap') == 12
colormap_vec = [[1:colormap_size] ; 0.5*[1:colormap_size] ; 0.5*[colormap_size:-1:1] ];
colormap_vec = colormap_vec'/max(colormap_vec(:));
set(evalin('base','zef.h_geoceles'),'colormap',colormap_vec);
end
  
if iscell(evalin('base','zef.reconstruction')) 
reconstruction = evalin('base',['zef.reconstruction{' int2str(frame_start) '}']);
else
reconstruction = evalin('base','zef.reconstruction');
end
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);

if evalin('base','zef.reconstruction_type') == 1
reconstruction = sqrt(sum(reconstruction.^2))';
elseif evalin('base','zef.reconstruction_type') == 6
reconstruction = (1/sqrt(3))*sum(reconstruction)';
end
if ismember(evalin('base','zef.reconstruction_type'), [1 6])
reconstruction = sum(reconstruction(s_i_ind),2)/3;
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
rec_x = reconstruction(1,:)';
rec_y = reconstruction(2,:)';
rec_z = reconstruction(3,:)';
rec_x = sum(rec_x(s_i_ind),2)/3;
rec_y = sum(rec_y(s_i_ind),2)/3;
rec_z = sum(rec_z(s_i_ind),2)/3;
n_vec_aux = cross(reuna_p{aux_brain_ind}(reuna_t{aux_brain_ind}(:,2),:)' - reuna_p{aux_brain_ind}(reuna_t{aux_brain_ind}(:,1),:)',...
reuna_p{aux_brain_ind}(reuna_t{aux_brain_ind}(:,3),:)' - reuna_p{aux_brain_ind}(reuna_t{aux_brain_ind}(:,1),:)')';
n_vec_aux = n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
reconstruction = sqrt((rec_x.*n_vec_aux(:,1)).^2 + (rec_y.*n_vec_aux(:,2)).^2 + (rec_z.*n_vec_aux(:,3)).^2);
end

if evalin('base','zef.reconstruction_type') == 3
reconstruction = sqrt((rec_x - reconstruction.*n_vec_aux(:,1)).^2 + (rec_y - reconstruction.*n_vec_aux(:,2)).^2 + (rec_z - reconstruction.*n_vec_aux(:,3)).^2);
end

if evalin('base','zef.reconstruction_type') == 4 
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec > 0);
reconstruction(I_aux_rec) = 0;
%reconstruction = reconstruction./max(abs(reconstruction(:)));
end

if evalin('base','zef.reconstruction_type') == 5 
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec <= 0);
reconstruction(I_aux_rec) = 0;
%reconstruction = reconstruction./max(abs(reconstruction(:)));
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
reconstruction = smooth_field(reuna_t{aux_brain_ind}, reconstruction, size(reuna_p{aux_brain_ind}(:,1),1),3);
end

if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
reconstruction = 10*log10(max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
end
end

h_surf_2 = trisurf(reuna_t{aux_brain_ind},reuna_p{aux_brain_ind}(:,1),reuna_p{aux_brain_ind}(:,2),reuna_p{aux_brain_ind}(:,3),reconstruction,'edgecolor','none');
set(h_surf_2,'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',[min_rec max_rec]); 
set(h_surf_2,'specularstrength',0.2);
set(h_surf_2,'specularexponent',0.8);
set(h_surf_2,'SpecularColorReflectance',0.8);
set(h_surf_2,'diffusestrength',1);
set(h_surf_2,'ambientstrength',1);
h_colorbar = colorbar('EastOutside','Position',[0.95 0.647 0.01 0.29]);
%set(h_colorbar,'layer','bottom');
lighting phong;

h_axes_text = axes('position',[0.656 0.95 0.5 0.05],'visible','off');
set(h_axes_text,'tag','image_details');
h_text = text(0, 0.5, ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + 0*evalin('base','zef.inv_time_3'),'%0.6f') ' s']);
set(h_text,'visible','on');
set(h_axes_text,'layer','bottom');
axes(evalin('base','zef.h_axes1'));

else
    
h_surf = trimesh(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),'edgecolor','none','facecolor',color_str);
set(h_surf,'specularstrength',0.1);
set(h_surf,'diffusestrength',0.5);
set(h_surf,'ambientstrength',0.85);
set(h_surf,'facealpha',evalin('base','zef.layer_transparency'));
if not(evalin('base','zef.visualization_type')==3);
lighting flat;
end

end
end
end
end

view(evalin('base','zef.azimuth'),evalin('base','zef.elevation'));
axis('image');
camva(evalin('base','zef.cam_va'));
if evalin('base','zef.axes_visible')
set(evalin('base','zef.h_axes1'),'visible','on');
set(evalin('base','zef.h_axes1'),'xGrid','on');
set(evalin('base','zef.h_axes1'),'yGrid','on');
set(evalin('base','zef.h_axes1'),'zGrid','on');
else
set(evalin('base','zef.h_axes1'),'visible','off');
set(evalin('base','zef.h_axes1'),'xGrid','off');
set(evalin('base','zef.h_axes1'),'yGrid','off');
set(evalin('base','zef.h_axes1'),'zGrid','off');
end
drawnow;    
    
f_ind_aux = 1;
for f_ind = frame_start + frame_step : frame_step : frame_stop
pause(1/30);
f_ind_aux = f_ind_aux + 1;
waitbar(f_ind_aux/number_of_frames,h_waitbar,['Frame ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '.'])
reconstruction = evalin('base',['zef.reconstruction{' int2str(f_ind) '}']);
reconstruction = reconstruction(:);  
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);

if evalin('base','zef.reconstruction_type') == 1
reconstruction = sqrt(sum(reconstruction.^2))';
elseif evalin('base','zef.reconstruction_type') == 6
reconstruction = (1/sqrt(3))*sum(reconstruction)';
end
if ismember(evalin('base','zef.reconstruction_type'), [1 6])
reconstruction = sum(reconstruction(s_i_ind),2)/3;
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
rec_x = reconstruction(1,:)';
rec_y = reconstruction(2,:)';
rec_z = reconstruction(3,:)';
rec_x = sum(rec_x(s_i_ind),2)/3;
rec_y = sum(rec_y(s_i_ind),2)/3;
rec_z = sum(rec_z(s_i_ind),2)/3;
n_vec_aux = cross(reuna_p{aux_brain_ind}(reuna_t{aux_brain_ind}(:,2),:)' - reuna_p{aux_brain_ind}(reuna_t{aux_brain_ind}(:,1),:)',... 
 reuna_p{aux_brain_ind}(reuna_t{aux_brain_ind}(:,3),:)' - reuna_p{aux_brain_ind}(reuna_t{aux_brain_ind}(:,1),:)')';
n_vec_aux = n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
reconstruction = sqrt((rec_x.*n_vec_aux(:,1)).^2 + (rec_y.*n_vec_aux(:,2)).^2 + (rec_z.*n_vec_aux(:,3)).^2);
end

if evalin('base','zef.reconstruction_type') == 3
reconstruction = sqrt((rec_x - reconstruction.*n_vec_aux(:,1)).^2 + (rec_y - reconstruction.*n_vec_aux(:,2)).^2 + (rec_z - reconstruction.*n_vec_aux(:,3)).^2);
end

if evalin('base','zef.reconstruction_type') == 4
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec > 0);
reconstruction(I_aux_rec) = 0;
%reconstruction = reconstruction./max(abs(reconstruction(:)));
end

if evalin('base','zef.reconstruction_type') == 5 
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec <= 0);
reconstruction(I_aux_rec) = 0;
%reconstruction = reconstruction./max(abs(reconstruction(:)));
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
reconstruction = smooth_field(reuna_t{aux_brain_ind}, reconstruction, size(reuna_p{aux_brain_ind}(:,1),1),3);
end

if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
reconstruction = 10*log10(max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
end
end

delete(h_surf_2);
delete(h_axes_text);

axes(evalin('base','zef.h_axes1'));
h_surf_2 = trisurf(reuna_t{aux_brain_ind},reuna_p{aux_brain_ind}(:,1),reuna_p{aux_brain_ind}(:,2),reuna_p{aux_brain_ind}(:,3),reconstruction,'edgecolor','none');
set(h_surf_2,'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',[min_rec max_rec]); 
set(h_surf_2,'specularstrength',0.2);
set(h_surf_2,'specularexponent',0.8);
set(h_surf_2,'SpecularColorReflectance',0.8);
set(h_surf_2,'diffusestrength',1);
set(h_surf_2,'ambientstrength',1);
camorbit(frame_step*evalin('base','zef.orbit_1')/15,frame_step*evalin('base','zef.orbit_2')/15);
lighting phong;

h_axes_text = axes('position',[0.656 0.95 0.5 0.05],'visible','off');
set(h_axes_text,'tag','image_details');
h_text = text(0, 0.5, ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + frame_step*(f_ind_aux - 1)*evalin('base','zef.inv_time_3'),'%0.6f') ' s']);
set(h_text,'visible','on');
set(h_axes_text,'layer','bottom');
drawnow;

end
    
else
    
    

i = 0;

for k = 1 : 9
switch k
    case 1
        on_val = evalin('base','zef.d1_on');
        visible_val = evalin('base','zef.d1_visible');
        color_str =  evalin('base','zef.d1_color');
    case 2
        on_val = evalin('base','zef.d2_on');
        visible_val = evalin('base','zef.d2_visible');
        color_str = evalin('base','zef.d2_color');
    case 3
        on_val = evalin('base','zef.d3_on');
        visible_val = evalin('base','zef.d3_visible');
        color_str = evalin('base','zef.d3_color');
    case 4
        on_val = evalin('base','zef.d4_on');
        visible_val = evalin('base','zef.d4_visible');
        color_str = evalin('base','zef.d4_color');
    case 5
        on_val = evalin('base','zef.w_on');
        visible_val = evalin('base','zef.w_visible');
        color_str = evalin('base','zef.w_color');
    case 6
        on_val = evalin('base','zef.g_on');
        visible_val = evalin('base','zef.g_visible');
        color_str = evalin('base','zef.g_color');
    case 7
        on_val = evalin('base','zef.c_on');
        visible_val = evalin('base','zef.c_visible');
        color_str = evalin('base','zef.c_color');
    case 8
        on_val = evalin('base','zef.sk_on');
        visible_val = evalin('base','zef.sk_visible');
        color_str = evalin('base','zef.sk_color');
    case 9
        on_val = evalin('base','zef.sc_on');
        visible_val = evalin('base','zef.sc_visible');
        color_str = evalin('base','zef.sc_color');
    end
if on_val 
i = i + 1;    
if visible_val
h_surf = trimesh(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),'edgecolor','none','facecolor',color_str);
set(h_surf,'specularstrength',0.1);
set(h_surf,'diffusestrength',0.5);
set(h_surf,'ambientstrength',0.85);
set(h_surf,'facealpha',evalin('base','zef.layer_transparency'));
lighting flat;
end
end
end

view(evalin('base','zef.azimuth'),evalin('base','zef.elevation'));
axis('image');
camva(evalin('base','zef.cam_va'));
if evalin('base','zef.axes_visible')
set(evalin('base','zef.h_axes1'),'visible','on');
set(evalin('base','zef.h_axes1'),'xGrid','on');
set(evalin('base','zef.h_axes1'),'yGrid','on');
set(evalin('base','zef.h_axes1'),'zGrid','on');
else
set(evalin('base','zef.h_axes1'),'visible','off');
set(evalin('base','zef.h_axes1'),'xGrid','off');
set(evalin('base','zef.h_axes1'),'yGrid','off');
set(evalin('base','zef.h_axes1'),'zGrid','off');
end
drawnow;


end


hold off;
rotate3d on;
if evalin('base','zef.visualization_type')==3 & iscell(evalin('base','zef.reconstruction'))
close(h_waitbar);
end