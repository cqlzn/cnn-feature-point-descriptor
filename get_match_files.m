function [ims,match_points_cell] = get_match_files(image_path,output_file_path,suffix)

% deploy = 'models/A16.prototxt'; caffemodel = 'models/A16.caffemodel';
deploy = 'models/C128.prototxt'; caffemodel = 'models/C128.caffemodel';

if nargin<3, suffix = 'jpg'; end  %jpg, png or other format

suffix_len = length(suffix);

if ~exist(image_path,'dir')
    error('%s not found!\n',image_path);
end

if ~exist(output_file_path,'dir')
    cmd = ['mkdir ' fullfile(output_file_path)];
    system(cmd);
end

feature_points_path = fullfile(output_file_path,'feature_points');
match_points_path = fullfile(output_file_path,'match_points');

if ~exist(feature_points_path,'dir')
    cmd = ['mkdir ' fullfile(feature_points_path)];
    system(cmd);
end

if ~exist(match_points_path,'dir')
    cmd = ['mkdir ' fullfile(match_points_path)];
    system(cmd);
end

dirstruct = dir(sprintf('%s/*.%s',image_path,suffix));
dircell = struct2cell(dirstruct)';
im_names = dircell(:,1);
im_num = length(im_names);
ims = cell(im_num,1);

force_gray = true;
net = caffe.Net(deploy, caffemodel, 'test');

caffe.set_mode_gpu();
caffe.set_device(0);
%%
for i = 1:im_num
    ims{i}.name = im_names{i};
    ims{i}.matrix = imread(fullfile(image_path,ims{i}.name));
    [f,~] = vl_sift(single(rgb2gray(ims{i}.matrix)));
    %f(1,:) is the width(x), f(2,:) is the height(y), while in matlab the first is the row(height), the second is the column(width)
    ims{i}.points = unique(f(2:-1:1,:)','rows');  
    %%%
    main_name = ims{i}.name(1:end-suffix_len-1);
    fp = fopen(sprintf('%s.txt',fullfile(feature_points_path,main_name)),'wt');
    for j = 1:size(ims{i}.points,1)
        fprintf(fp,'%f %f\n',ims{i}.points(j,2),ims{i}.points(j,1)); %save as (width,height)
    end
    
    fclose(fp);
    % feature descriptor
    fprintf('\nComputing descriptors of %s...(%d in %d)\n',ims{i}.name,i,im_num);
    ims{i}.descr = compute_descriptor(ims{i}.matrix ,ims{i}.points, net, force_gray);
end
caffe.reset_all();
match_points_cell = cell(im_num,im_num);
%%
for i = 1:im_num-1
    name1 = ims{i}.name;
    main_name1 = ims{i}.name(1:end-suffix_len-1);
    fprintf('\nMatching %s with the rest...(%d in %d)\n',ims{i}.name,i,im_num);
    im_i_descr = ims{i}.descr;
    parfor j = i+1:im_num
        [curr_match_points,~] = vl_ubcmatch(im_i_descr, ims{j}.descr,1.7);
        curr_match_points = curr_match_points';

        main_name2 = ims{j}.name(1:end-suffix_len-1);
        fp = fopen(sprintf('%s.txt',fullfile(match_points_path,sprintf('%s_%s',main_name1,main_name2))),'wt');
        curr_match_points_save = curr_match_points - 1; %count start from 0,while matlab is from 1
        for k = 1:size(curr_match_points,1)
            fprintf(fp,'%d %d\n',curr_match_points_save(k,1),curr_match_points_save(k,2));
        end
        fclose(fp);
        match_points_cell{i,j} = curr_match_points;
        fprintf('%s and %s has been matched!\n',name1,ims{j}.name);
    end
end