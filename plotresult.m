for ii = [1,2]
    figure;
    imagesc(colorfillmap);
    axis equal
    axis off
    set(gcf,'color',[1 1 1]);
    if any(colorfillmap(:)==0)
        colormap([1 1 1; colordata(1:max(colorfillmap(:)),:)/255]);
    else
        colormap(colordata/255);
    end
end

textStrings = num2str(numfillmap(:), '%0.0f');
tempind = all(textStrings == [repmat(' ',1,size(textStrings,2)-1) '0'],2);
textStrings(tempind,:) = repmat(' ',sum(tempind),size(textStrings,2));
textStrings = strtrim(cellstr(textStrings));
[x, y] = meshgrid(1:total_col, 1:total_row);
hStrings = text(x(:), y(:), textStrings(:), 'HorizontalAlignment', 'center');
textColors = ones(total_col*total_row, 3); 
textSize = fontsize * ones(total_col*total_row, 1); 
set(hStrings, {'Color'}, num2cell(textColors, 2), {'FontSize'}, num2cell(textSize, 2));


hold on
for ii = 1:numel(path_lookup)
    path = path_lookup{ii};
    if weight_fix(ii) == 1
        path = [0.75*path(1,:)+0.25*path(2,:) ; path(2:end-1,:); 0.75*path(end,:)+0.25*path(end-1,:)];
        plot(path(:,2), path(:,1),'-','color',[1 1 1]);
    end
end
