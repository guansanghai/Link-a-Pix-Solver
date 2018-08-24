function [path, vec_fillmap] = findpath(start, target, distance, puzzle_row, puzzle_col, total_row, total_col)

path = {};
vec_fillmap = [];

n = (distance - sum(abs(start - target))) / 2;

if n < 0 || n ~= fix(n)
    return
end

startind = (puzzle_row == start(1)) & (puzzle_col == start(2));
targetind = (puzzle_row == target(1)) & (puzzle_col == target(2));
puzzle_row(startind | targetind) = [];
puzzle_col(startind | targetind) = [];

minrow = max(1, min(start(1), target(1)) - n);
maxrow = min(total_row, max(start(1), target(1)) + n);
mincol = max(1, min(start(2), target(2)) - n);
maxcol = min(total_col, max(target(2), target(2)) + n);
tempind = puzzle_row >= minrow & puzzle_row <= maxrow ...
    & puzzle_col >= mincol & puzzle_col <= maxcol;
puzzle_row = puzzle_row(tempind);
puzzle_col = puzzle_col(tempind);

path = searchpath(path, distance, start, target, start, [puzzle_row, puzzle_col], total_row, total_col);

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

