function show_match_pairs(im1, im2, points1, points2, match_points)

rows1 = size(im1,1);
rows2 = size(im2,1);

if (rows1 < rows2)
     im1(rows2,1) = 0;
else
     im2(rows1,1) = 0;
end

im = cat(2,im1,im2);   
figure('Position', [0 0 size(im,2) size(im,1)]);
%imagesc(im);
imshow(im);
hold on;
cols = size(im1,2);
for i=1:size(match_points)
    curr_pair = match_points(i,:);
    line([points1(curr_pair(1),2) points2(curr_pair(2),2)+cols], [points1(curr_pair(1),1) points2(curr_pair(2),1)],'LineWidth',1,'Color','g');
end
