pkg load image;

function main
    img_size = [540, 540];
    kernel_size = [7, 7];
    neighbor_size = 3;
    threshold = [10 15];
    sigma = [0.5 2 8];
    pattern = ['ro'; 'go'];
    pattern_size = [5, 2];

    img = imread('./eiffel.jpg');
    img = imresize(img, img_size);
    figure;
    imshow(img);
    hold on;
    img = rgb2gray(img);
    img = double(img) / 255.0;

    for j = 1 : 2
        filtered_img1 = filtering(img, kernel_size, sigma(j));
        filtered_img2 = filtering(img, kernel_size, sigma(j + 1));
        D = filtered_img2 - filtered_img1;

        corners = find_peak(D, neighbor_size, threshold(j));
        disp(sum(corners(:)));
        [hot_row, hot_col] = find(corners == 1);

        for i = 1 : size(hot_row, 1)
            plot(hot_col(i), hot_row(i), pattern(j, :), 'MarkerSize', pattern_size(j));
        end
    end

    saveas(gcf, 'corners.png');
    hold off;
end

function peak_map = find_peak(map, neighbor_size, threshold)
    peak_map = zeros(size(map));
    height = size(map, 1);
    width = size(map, 2);
    for i = (neighbor_size - 1) / 2 + 1 : height - (neighbor_size - 1) / 2
        for j = (neighbor_size - 1) / 2 + 1 : width - (neighbor_size - 1) / 2
            flag1 = 1;
            flag2 = 1;
            % two standards: peak & above threshold
            for m = -(neighbor_size - 1) / 2 : (neighbor_size - 1) / 2
                for n = -(neighbor_size - 1) / 2 : (neighbor_size - 1) / 2
                    if map(i, j) < map(i + m, j + n)
                        flag1 = 0;
                    elseif map(i, j) > map(i + m, j + n)
                        flag2 = 0;
                    end
                end
            end
            if flag1 == 1 || flag2 == 1
                if abs(map(i, j)) > threshold
                    peak_map(i, j) = 1;
                end
            end
        end
    end
end

function filtered_img = filtering(img, kernel_size, sigma)
    gaussian_kernel = kernel(kernel_size, sigma);
    filtered_img = zeros(size(img));
    padding_len = (kernel_size - 1) / 2;
    height = size(img, 1);
    width = size(img, 2);
    conv_result = conv2(img, gaussian_kernel);
    filtered_img = conv_result(padding_len + 1 : height + padding_len, ...
        padding_len + 1 : width + padding_len);
end

% construction of high-pass and low-pass gaussian filters
% rho is set 0
function gaussian_kernel = kernel(kernel_size, sigma)
    gaussian_kernel = zeros(kernel_size);
    center_y = fix((kernel_size(1) + 1) / 2);
    center_x = fix((kernel_size(2) + 1) / 2);
    for y = 1 : kernel_size(1)
        for x = 1 : kernel_size(2)
            diff = (x - center_x) ^ 2 + (y - center_y) ^ 2;
            gaussian_kernel(y, x) = exp(-diff / (2 * sigma ^ 2));
        end
    end
end

main
