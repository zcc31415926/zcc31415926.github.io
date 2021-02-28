pkg load image;

function main
    % high-pass and low-pass filters have different sigma values
    sigma_high = 25;
    sigma_low = 5;
    level = 3;
    image_size = [360, 360];

    einstein = imread('/home/charlie/Downloads/CV/CV_problem_set_1/code_3/einstein.png');
    marilyn = imread('/home/charlie/Downloads/CV/CV_problem_set_1/code_3/marilyn.png');
    einstein = imresize(einstein, image_size);
    marilyn = imresize(marilyn, image_size);
    einstein = double(einstein) / 255;
    marilyn = double(marilyn) / 255;

    gaussian_kernel_high = kernel(image_size, sigma_high);
    gaussian_kernel_low = kernel(image_size, sigma_low);

    filtered_einstein = einstein;
    filtered_marilyn = marilyn;
    for i = 1 : level
        filtered_einstein = filtering(filtered_einstein, gaussian_kernel_low);
        filtered_marilyn = filtering(filtered_marilyn, 1 - gaussian_kernel_high);
    end
    hybrid = filtered_einstein + filtered_marilyn;

    imwrite(filtered_einstein, 'filtered_einstein.jpg');
    imwrite(filtered_marilyn, 'filtered_marilyn.jpg');
    imwrite(hybrid, 'hybrid.jpg');
end

% high-pass and low-pass filtering process
function filtered_image = filtering(image, kernel)
    freq_image = fftshift(fft2(image));
    filtered_freq_image = freq_image .* kernel;
    filtered_image = ifft2(ifftshift(filtered_freq_image));
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
