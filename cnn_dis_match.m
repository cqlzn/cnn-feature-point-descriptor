function match_point = cnn_dis_match(im1,im2,points1,points2,deploy,caffemodel)
%each row of match_point is a pair of corresponding patches' point index

net = caffe.Net(deploy, caffemodel, 'test');
caffe.set_mode_gpu();
caffe.set_device(0);
%% computing descriptors
fprintf('Computing image1 descriptors...\n');
discriptor1 = compute_descriptor(im1 ,points1, net);
fprintf('Computing image2 descriptors...\n');
discriptor2 = compute_descriptor(im2 ,points2, net);

caffe.reset_all();
%% matching descriptors
fprintf('Matching...\n');
[match_point, ~] = vl_ubcmatch(discriptor1,discriptor2,1.7);
match_point = match_point';
end

