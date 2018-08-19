figure;
imagesc(colorfillmap);
axis equal
colormap([1 1 1; colordata(1:max(colorfillmap(:)),:)/255]);
textStrings = num2str(numfillmap(:), '%0.0f');
tempind = all(textStrings == [repmat(' ',1,size(textStrings,2)-1) '0'],2);
textStrings(tempind,:) = repmat(' ',sum(tempind),size(textStrings,2));
textStrings = strtrim(cellstr(textStrings));
[x, y] = meshgrid(1:total_col, 1:total_row);
hStrings = text(x(:), y(:), textStrings(:), 'HorizontalAlignment', 'center');
textColors = ones(total_col*total_row, 3); 
textSize = fontsize * ones(total_col*total_row, 1); 
set(hStrings, {'Color'}, num2cell(textColors, 2), {'FontSize'}, num2cell(textSize, 2));
set(gcf,'color',[1 1 1]);
axis off;

% axis on;
% xticks(1:total_col)
% yticks(1:total_row)
% grid on
% xlim([0.5 total_col+0.5]);
% ylim([0.5 total_row+0.5]);