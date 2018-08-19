function [path, vec_fillmap] = findpathdfs(row1, col1, row2, col2, num, puzzle_row, puzzle_col, total_row, total_col)

path = {};
vec_fillmap = [];

n = (num - abs(row2 - row1) - abs(col2 - col1) - 1) / 2;

if n < 0 || n ~= fix(n)
    return
end

startind = (puzzle_row == row1) & (puzzle_col == col1);
targetind = (puzzle_row == row2) & (puzzle_col == col2);
puzzle_row(startind | targetind) = [];
puzzle_col(startind | targetind) = [];

minrow = max(1, min(row1, row2) - n);
maxrow = min(total_row, max(row1, row2) + n);
mincol = max(1, min(col1, col2) - n);
maxcol = min(total_col, max(col1, col2) + n);

tempind = puzzle_row >= minrow & puzzle_row <= maxrow ...
    & puzzle_col >= mincol & puzzle_col <= maxcol;
puzzle_row = puzzle_row(tempind);
puzzle_col = puzzle_col(tempind);

path = searchpathdfs(path, num-1, [row1 col1], [row2 col2], [minrow mincol maxrow maxcol], [row1 col1], [puzzle_row, puzzle_col]);

if ~isempty(path)
    for ii = 1:numel(path)
        temppath = path{ii};
        tempfillmap = zeros(total_row, total_col);
        tempfillmap(sub2ind([total_row, total_col], temppath(:,1), temppath(:,2))) = 1;
        vec_fillmap = [vec_fillmap; tempfillmap(:).'];%#ok
    end
end

[~,ind] = unique(vec_fillmap, 'rows');
vec_fillmap = vec_fillmap(ind,:);
path = path(ind);

end

