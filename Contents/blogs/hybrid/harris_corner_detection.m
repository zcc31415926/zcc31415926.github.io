pkg load image;

function main
    img_size = [540, 540];
    window_size = [5, 5];
    k = 0.04;
    sigma_filter = 5;
    sigma_blurring = 50;
    % 'gaussian': gaussian window
    % otherwise: uniform window
    filter_choice = 'gaussian';

    img = imread('./eiffel.jpg');
    img = imresize(img, img_size);
    img = double(img) / 255.0;

    blurred_img = blur(img, sigma_blurring);
    blurred_img = real(blurred_img);

    % image save-and-load
    % use of Python script: Matlab imread function on blurredImg.png returns an image not in [0, 255]
    imwrite(blurred_img, 'blurredImg.png');
    unix('python resave_img.py blurredImg.png blurredImg.png');
    img = imread('blurredImg.png');
    img = double(img) / 255.0;

    corners = harris(img, window_size, k, filter_choice, sigma_filter);
    disp('number of corners detected:');
    disp(sum(corners(:)));

    [hot_row, hot_col] = find(corners == 1);

    figure;
    imshow(img);
    hold on;

    for i = 1:size(hot_row,1)
        plot(hot_col(i), hot_row(i), 'ro', 'MarkerSize', 5);
    end

    saveas(gcf,'corners.png');
    hold off;
end

function blurred_img = blur(img, sigma)
    kernel = gaussian_kernel([size(img, 1), size(img, 2)], sigma);
    freq_img = fftshift(fft2(img));
    blurred_freq_img = freq_img .* kernel;
    blurred_img = ifft2(ifftshift(blurred_freq_img));
end

% construction of high-pass and low-pass gaussian filters
% rho is set 0
function kernel = gaussian_kernel(kernel_size, sigma)
    kernel = zeros(kernel_size);
    center_y = fix((kernel_size(1) + 1) / 2);
    center_x = fix((kernel_size(2) + 1) / 2);
    for y = 1 : kernel_size(1)
        for x = 1 : kernel_size(2)
            diff = (x - center_x) ^ 2 + (y - center_y) ^ 2;
            kernel(y, x) = exp(-diff / (2 * sigma ^ 2));
        end
    end
end

function corners = harris(img, window_size, k, filter_choice, sigma)
    img_gray = rgb2gray(img);
    width = size(img_gray, 2);
    height = size(img_gray, 1);

    [gradient_x, gradient_y] = gradient(img_gray);
    Ixx = gradient_x .* gradient_x;
    Iyy = gradient_y .* gradient_y;
    Ixy = gradient_x .* gradient_y;

    h = fspecial('gaussian', [6, 6], 1);
    Ixx = conv2(Ixx, h, 'same');
    Iyy = conv2(Iyy, h, 'same');
    Ixy = conv2(Ixy, h, 'same');

    corners = zeros(height - window_size(1) + 1, width - window_size(2) + 1);

    filter = ones(window_size);
    if strcmp(filter_choice, 'gaussian')
        % gaussian window construction with size window_size
        filter = gaussian_kernel(window_size, sigma);
    end

    %for i = 1 : height - window_size(1) + 1
        %for j = 1 : width - window_size(2) + 1
            %patch = img_gray(i : i + window_size(1) - 1, j : j + window_size(2) - 1);
            %filtered_patch = patch .* filter;
            %M = sum(filtered_patch(:));
            %corners(i, j) = det(M) - k * trace(M) ^ 2;
        %end
    %end

    for i = 1 : height
        for j = 1 : width
            M = [Ixx(i, j), Ixy(i, j); Ixy(i, j), Iyy(i, j)];
            corners(i, j) = det(M) - k * trace(M) ^ 2;
        end
    end

    corner_avg = mean(corners(:));
    corner_max = max(corners(:));
    % threshold value set to 10 times the average cornerness
    % corner_threshold = 10 * corner_avg;
    % threshold value set to 0.01 times the max cornerness
    corner_threshold = 0.02 * corner_max;
    corners(corners < corner_threshold) = 0;
    % built-in NMS function; return: bool matrix
    corners = imregionalmax(corners);
end

main
