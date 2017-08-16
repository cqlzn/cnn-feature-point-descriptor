function discriptor = compute_descriptor(im, points, net, force_gray)

if nargin < 4
    force_gray = 1;
end

input_size = size(net.blobs('data').get_data);
discriptor_length = size(net.blobs('feat').get_data, 1);
patch_size = size(net.blobs('data').get_data,1);
batch_size = input_size(4);

input_data = zeros(input_size,'single');
count = 0;
iter = 0;
point_num = size(points,1);
discriptor = zeros(discriptor_length, point_num,'single');
for i = 1:point_num
    % input_data is Weight x Hidth x Channel x Num
    patch = get_patch(im,points(i,:),patch_size, force_gray);
    patch = patch(:, :, [3, 2, 1]);  % permute channels from RGB to BGR
    patch = permute(patch, [2, 1, 3]);  % flip width and height
    count = count + 1;
    patch = single(patch);
    
    input_data(:,:,:,count) = patch/256;
    
    % input_data(:,:,:,count) = patch;
    
    if count == batch_size
        input_data = {input_data};
        dist = net.forward(input_data);
        dist = dist{1};
        count = 0;
        iter = iter + 1;
        discriptor(:,(iter-1)*batch_size+1:iter*batch_size) = dist;
        fprintf('%d points in %d has done\n', iter*batch_size, point_num);
        input_data = zeros(input_size,'single');
    end
end

if count ~= 0
    input_data = {input_data};
    dist = net.forward(input_data);
    dist = dist{1};
    iter = iter + 1;
    discriptor(:,(iter-1)*batch_size+1:end) = dist(:,1:count);
    fprintf('%d points in %d has done\n', point_num, point_num);
end