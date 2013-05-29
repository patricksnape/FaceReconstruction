function SaveFigures(subject, tech, n, tex, texrecov)
    close all;
    hfig = figure(1);
    dataPath = 'data/results';

    set(hfig,...
        'InvertHardcopy', 'off',...
        'Position', [300 300 170 150],... %[left, bottom, width, height]
        'PaperPositionMode', 'auto',...
        'Color', [0 0 0]);

    TexturizeRecoveredFace(tex, n);
    saveas(hfig, sprintf('%s/%s/%s-%s.fig', dataPath, subject, tech, subject));
    set(hfig, 'visible', 'off');

    % Chin
    view([128 30])
    filePath = sprintf('%s/%s/%s-%s-chin.png', dataPath, subject, tech, subject);
    print('-dpng',filePath);
    % Profile
    view([0 0])
    filePath = sprintf('%s/%s/%s-%s-profile.png', dataPath, subject, tech, subject);
    print('-dpng',filePath);
    % Side
    view([0 0]);
    camup('manual');
    camup([0 0 1]);
    camorbit(90, 90);
    camorbit(-45, 0, [0 0 1]);
    filePath = sprintf('%s/%s/%s-%s-side.png', dataPath, subject, tech, subject);
    print('-dpng',filePath);

    imshow(n, 'Border','tight');
    filePath = sprintf('%s/%s/%s-%s-normals.png', dataPath, subject, tech, subject);
    print('-dpng',filePath);
    
    if (strcmp(tech, 'novel'))
        imshow(texrecov, 'Border','tight');
        filePath = sprintf('%s/%s/%s-%s-tex.png', dataPath, subject, tech, subject);
        print('-dpng',filePath);
    end
    clf;
    close all;
end
