function fplot = fm_plot(fm)
    n = size(fm,3);
    ha = tight_subplot(n, 1, [0 0], [0 0], [0 0]);
    for i = 1:n
        axes(ha(i));
        imshow(fm(:,:,i));
    end
end