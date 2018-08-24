function path = searchpath(path, length, start, target, temppath, obstancle, total_row, total_col)

if length == 0 && all(start == target)
    path = [path, temppath];
    return    
end

n = (length - abs(start(1) - target(1)) - abs(start(2) - target(2))) / 2;

if (length ~= 0) && (n >= 0) && (n == fix(n))
    offset = {[1 0], [-1 0], [0 1], [0 -1]};
    for ii = 1:4
        nextstart = start + offset{ii};
        if nextstart(1) >= 1 && nextstart(2) >= 1 ...
                && nextstart(1) <= total_row && nextstart(2) <= total_col
            if ~any(all(nextstart == temppath, 2)) && ~any(all(nextstart == obstancle, 2))
                path = searchpath(path, length-1, nextstart, target, [temppath; nextstart], obstancle, total_row, total_col);
            end
        end
    end
end
    
end


