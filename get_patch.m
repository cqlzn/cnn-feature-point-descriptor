function patch = get_patch(im, point, patch_size, force_gray)

if nargin < 4, force_gray = 1; end

[height, width, channel] = size(im);
patch = zeros(patch_size,patch_size,channel,'uint8');
im_loc = [point(1) - (patch_size-1)/2, point(1) + (patch_size-1)/2, point(2) - (patch_size-1)/2, point(2) + (patch_size-1)/2];
im_loc = ceil(im_loc);
patch_loc = [1, patch_size, 1, patch_size];

if im_loc(1)<1
    patch_loc(1) = 2 - im_loc(1);
    im_loc(1) = 1;
end

if im_loc(2)>height
    patch_loc(2) = patch_size - (im_loc(2) - height);
    im_loc(2) = height;
end

if im_loc(3)<1
    patch_loc(3) = 2 - im_loc(3);
    im_loc(3) = 1;
end

if im_loc(4)>width
    patch_loc(4) = patch_size - (im_loc(4) - width);
    im_loc(4) = width;
end

patch(patch_loc(1):patch_loc(2),patch_loc(3):patch_loc(4),:) = im(im_loc(1):im_loc(2),im_loc(3):im_loc(4),:);

%rgb to gray
if force_gray
    if size(patch,3) == 3
        patch_gray = rgb2gray(patch);
    end
    patch(:,:,1) = patch_gray;
    patch(:,:,2) = patch_gray;
    patch(:,:,3) = patch_gray;
elseif size(patch,3) == 1
    patch_gray = patch;
    patch(:,:,1) = patch_gray;
    patch(:,:,2) = patch_gray;
    patch(:,:,3) = patch_gray;
end








