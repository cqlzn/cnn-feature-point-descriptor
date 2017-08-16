function match_pairs(im1_path,im2_path,num_of_lines,resz)

 %show all matching lines(-1) or limited lines(positive integer)
if nargin < 3, num_of_lines = -1; end
 
% resize input images 
if nargin < 4, resz = 1;end

if ~exist(im1_path, 'file'), error('Image %s not found!\n',im1_path); end
if ~exist(im2_path, 'file'), error('Image %s not found!\n',im2_path); end

im1 = imread(im1_path);
im2 = imread(im2_path);

im1 = imresize(im1, resz);
im2 = imresize(im2, resz);

if size(im1,3) == 3, im_g1 = rgb2gray(im1); else im_g1 = im1; end
if size(im2,3) == 3, im_g2 = rgb2gray(im2); else im_g2 = im1; end
%% get feature points
[f1,~] = vl_sift(single(im_g1));
[f2,~] = vl_sift(single(im_g2));
points1 = unique(f1(2:-1:1,:)','rows');
points2 = unique(f2(2:-1:1,:)','rows');
%% match two images
% match_points = cnn_dis_match(im1,im2,points1,points2,'models/A16.prototxt','models/A16.caffemodel');
match_points = cnn_dis_match(im1,im2,points1,points2,'models/C128.prototxt','models/C128.caffemodel');
fprintf('Find %d match points!\n', size(match_points,1));
%% show matching results
if num_of_lines ~= -1 && num_of_lines <= size(match_points,1)
    match_points = match_points(randperm(size(match_points,1), num_of_lines),:);
end
fprintf('Show %d match points!\n', size(match_points,1));
show_match_pairs(im1,im2,points1,points2,match_points);