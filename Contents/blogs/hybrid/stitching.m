% pkg load image;

function main
    img1 = imread('./keyboard1.jpg');
    img2 = imread('./keyboard2.jpg');
    [height1, width1, ~] = size(img1);
    [height2, width2, ~] = size(img2);

    [x1, y1, x2, y2] = get_frames(img1, img2, 4);

    H = compute_homography_matrix(x1, y1, x2, y2)

    [height, width, height_offset, width_offset] = ...
        determine_background(H, height1, width1, height2, width2);
    IMAGE = project_images(img1, img2, height, width, height_offset, width_offset, H);

    imshow(IMAGE / 255.0);
end

function IMAGE = project_images(img1, img2, height, width, height_offset, width_offset, H)
    [height1, width1, ~] = size(img1);
    [height2, width2, ~] = size(img2);
    IMAGE = zeros(height, width, 3);
    IMAGE(height_offset + 1 : height_offset + height1, width_offset + 1 : width_offset + width1, :) = img1;
    for i = 1 : height
        disp(i/height);
        for j = 1 : width
            target = [j - width_offset; i - height_offset; 1];
            source = H ^ -1 * target;
            source = source / source(3);
            source = fix(source);
            if (source(1) > 1) && (source(1) < width2)
                if (source(2) > 1) && (source(2) < height2)
                    for k = 1 : 3
                        IMAGE(i, j, k) = img2(source(2), source(1), k);
                    end
                end
            end
        end
    end
end

function H = compute_homography_matrix(x1, y1, x2, y2)
    num_frames = length(x1);

    A = zeros(num_frames * 2, 8);
    A(1 : 2 : num_frames * 2, 1 : 2) = [x2, y2];
    A(1 : 2 : num_frames * 2, 3) = ones(num_frames, 1);
    A(2 : 2 : num_frames * 2, 4 : 5) = [x2, y2];
    A(2 : 2 : num_frames * 2, 6) = ones(num_frames, 1);
    A(1 : 2 : num_frames * 2, 7 : 8) = [-x2 .* x1, -y2 .* x1];
    A(2 : 2 : num_frames * 2, 7 : 8) = [-x2 .* y1, -y2 .* y1];

    B = zeros(num_frames * 2, 1);
    for i = 1 : num_frames
        B(2 * i - 1) = x1(i);
        B(2 * i) = y1(i);
    end

    H = pinv(A) * B;
    H = [H(1), H(2), H(3); H(4), H(5), H(6); H(7), H(8), 1];
end

function [height, width, height_offset, width_offset] = ...
    determine_background(H, height1, width1, height2, width2)
    p1 = [0; 0; 1];
    p2 = [width2; 0; 1];
    p3 = [0; height2; 1];
    p4 = [width2; height2; 1];

    p1 = H * p1; p1 = p1 / p1(3);
    p2 = H * p2; p2 = p2 / p2(3);
    p3 = H * p3; p3 = p3 / p3(3);
    p4 = H * p4; p4 = p4 / p4(3);
    max_x = max([p1(1), p2(1), p3(1), p4(1)]);
    min_x = min([p1(1), p2(1), p3(1), p4(1)]);
    max_y = max([p1(2), p2(2), p3(2), p4(2)]);
    min_y = min([p1(2), p2(2), p3(2), p4(2)]);

    max_x = max([max_x, width1]);
    min_x = min([min_x, 0]);
    max_y = max([max_y, height1]);
    min_y = min([min_y, 0]);
    height = fix(max_y - min_y);
    width = fix(max_x - min_x);
    height_offset = fix(-min_y);
    width_offset = fix(-min_x);
end

function [x1, y1, x2, y2] = get_frames(img1, img2, num_frames)
    img1 = im2double(rgb2gray(img1));
    img2 = im2double(rgb2gray(img2));
    imshow(img1);
    [x1, y1] = ginput(num_frames);
    imshow(img2);
    [x2, y2] = ginput(num_frames);
    close;
end

% main
