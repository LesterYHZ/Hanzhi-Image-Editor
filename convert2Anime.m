function img_res = convert2Anime(img)
img_copy = img;
img_res = img;

% Key arguments -- please determine them according to specific images.

% Threshold for edge determining.
edge_thresh = 0.02;

edge_operator = 'sobel'; 

saturation_scalar = 2;

% Arguments for Bilateral filter.
radius=10; sigma=[3, 0.1]; 
loop_num = 1; 

% Adjust the saturation of img.
img_sa = saturation_adjust(img, saturation_scalar);

% Normalize image to [0,1].
img_f = (double(img_sa)) ./ 255;


if loop_num > 1
    img_f = bfilter2(img_f,radius,sigma);
    img_gray = rgb2gray(img_f);
    
    % Represent the edges using a mask.
    edge_mask = uint8(edge(img_gray, edge_operator, edge_thresh));
    
    for i=2:loop_num
        img_f = bfilter2(img_f,radius,sigma);
    end
elseif loop_num == 1
    img_f = bfilter2(img_f,radius,sigma);
    img_gray = rgb2gray(img_f);
    edge_mask = uint8(edge(img_gray, edge_operator, edge_thresh));    
end   


% Convert double-type image to uint8-type image for highlighting edges.
img_blur = uint8(img_f*255);

% Highlight edges using black color.
img_res(:,:,1) = img_blur(:,:,1) - img_blur(:,:,1) .* edge_mask;
img_res(:,:,2) = img_blur(:,:,2) - img_blur(:,:,2) .* edge_mask;
img_res(:,:,3) = img_blur(:,:,3) - img_blur(:,:,3) .* edge_mask;

end

function B = bfilter2(A,w,sigma)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pre-process input and select appropriate filter.    
% Verify that the input image exists and is valid.  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ~exist('A','var') || isempty(A)  
        error('Input image A is undefined or invalid.');  
    end  
    if ~isfloat(A) || ~sum([1,3] == size(A,3)) || min(A(:)) < 0 || max(A(:)) > 1  
        error(['Input image A must be a double precision ',...  
          'matrix of size NxMx1 or NxMx3 on the closed ',...  
          'interval [0,1].']);        
    end  
  
    % Verify bilateral filter window size.  
    if ~exist('w','var') || isempty(w) || numel(w) ~= 1 || w < 1  
        w = 5;  
    end  
    w = ceil(w);  
    
    % Verify bilateral filter standard deviations.  
    if ~exist('sigma','var') || isempty(sigma) || numel(sigma) ~= 2 || sigma(1) <= 0 || sigma(2) <= 0  
        sigma = [3 0.1];  
    end  
  
    % Apply either grayscale or color bilateral filtering.  
    if size(A,3) == 1  
        B = bfltGray(A,w,sigma(1),sigma(2));  
    else  
        B = bfltColor(A,w,sigma(1),sigma(2));  
    end 
end

function B = bfltColor(A,w,sigma_d,sigma_r)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Implements bilateral filter for color images.  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Convert input sRGB image to CIELab color space.  
    if exist('applycform','file')  
        A = applycform(A,makecform('srgb2lab'));  
    else  
        A = colorspace('Lab&lt;-RGB',A);  
    end  
  
    % Pre-compute Gaussian domain weights.  
    [X,Y] = meshgrid(-w:w,-w:w);  
    G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));  
  
    % Rescale range variance (using maximum luminance).  
    sigma_r = 100*sigma_r;  
  
    % Create waitbar.  
    h = waitbar(0,'Applying bilateral filter...');  
    set(h,'Name','Bilateral Filter Progress');  
  
    % Apply bilateral filter.  
    dim = size(A);  
    B = zeros(dim);  
    for i = 1:dim(1)  
        for j = 1:dim(2)  
            % Extract local region.  
            iMin = max(i-w,1);  
            iMax = min(i+w,dim(1));  
            jMin = max(j-w,1);  
            jMax = min(j+w,dim(2));  
            I = A(iMin:iMax,jMin:jMax,:);  
        
            % Compute Gaussian range weights.  
            dL = I(:,:,1)-A(i,j,1);  
            da = I(:,:,2)-A(i,j,2);  
            db = I(:,:,3)-A(i,j,3);  
            H = exp(-(dL.^2+da.^2+db.^2)/(2*sigma_r^2));  
        
            % Calculate bilateral filter response.  
            F = H.*G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);  
            norm_F = sum(F(:));  
            B(i,j,1) = sum(sum(F.*I(:,:,1)))/norm_F;  
            B(i,j,2) = sum(sum(F.*I(:,:,2)))/norm_F;  
            B(i,j,3) = sum(sum(F.*I(:,:,3)))/norm_F;  
                  
        end  
        waitbar(i/dim(1));  
    end  
  
    % Convert filtered image back to sRGB color space.  
    if exist('applycform','file')  
        B = applycform(B,makecform('lab2srgb'));  
    else    
        B = colorspace('RGB&lt;-Lab',B);  
    end  
  
    % Close waitbar.  
    close(h);
end

function B = bfltGray(A,w,sigma_d,sigma_r)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Implements bilateral filtering for grayscale images.  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Pre-compute Gaussian distance weights.  
    [X,Y] = meshgrid(-w:w,-w:w);  
    G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));  
  
    % Create waitbar.  
    h = waitbar(0,'Applying bilateral filter...');  
    set(h,'Name','Bilateral Filter Progress');  
  
    % Apply bilateral filter.  
    dim = size(A);  
    B = zeros(dim);  
    for i = 1:dim(1)  
        for j = 1:dim(2)  
            % Extract local region.  
            iMin = max(i-w,1);  
            iMax = min(i+w,dim(1));  
            jMin = max(j-w,1);  
            jMax = min(j+w,dim(2));  
            I = A(iMin:iMax,jMin:jMax);
        
            % Compute Gaussian intensity weights.  
            H = exp(-(I-A(i,j)).^2/(2*sigma_r^2));  
        
            % Calculate bilateral filter response.  
            F = H.*G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);  
            B(i,j) = sum(F(:).*I(:))/sum(F(:));  
                 
        end  
        waitbar(i/dim(1));  
    end  
  
    % Close waitbar.  
    close(h); 
end

function img_res = saturation_adjust( img, S_scalar )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Adjust the saturation of input image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    img_double = double(img);
    img_gray = double(rgb2gray(img));
    S_template = img_double;
    
    % S_template -- Saturation changing template.
    % For saturation changing, we normally use a grayscale version of original image as templete to complete the interpolation and extrapolation. 
    % If you are not familiar with the interpolation and extrapolation, see here: http://netpbm.sourceforge.net/doc/extendedopacity.html
    S_template(:,:,1)=img_gray; S_template(:,:,2)=img_gray;S_template(:,:,3)=img_gray;
    
    % Implement interpolation and extrapolation. 
    img_res = (1-S_scalar).*S_template  +S_scalar.*img_double;
    
    img_res = uint8(img_res);
end

