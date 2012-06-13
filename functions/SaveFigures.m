function SaveFigures(subject, tech, n, tex, texrecov)
    close all;
    hfig=figure(1);
    dataPath = 'data/results';

    set(hfig,...
        'InvertHardcopy','off',...
        'Position',[300 300 170 150],... %[left, bottom, width, height]
        'PaperPositionMode','auto',...
        'Color',[0 0 0]); % black

    TexturizeRecoveredFace(tex, n);
     
    % Chin
    view([128 30])
    filePath = sprintf('%s/%s/%s-%s-chin.png', dataPath, subject, tech, subject);
    print('-dpng',filePath);
    % Profile
    view([0 0])
    filePath = sprintf('%s/%s/%s-%s-profile.png', dataPath, subject, tech, subject);
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
