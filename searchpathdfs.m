function path = searchpathdfs(path, length, start, target, scale, temppath, obstancle)

if length == 0 && all(start == target)
    path = [path, temppath];
    return    
end

if length ~= 0
    offset = {[1 0], [-1 0], [0 1], [0 -1]};
    for ii = 1:4
        nextstart = start + offset{ii};
        if nextstart(1) >= scale(1) && nextstart(2) >= scale(2) ...
                && nextstart(1) <= scale(3) && nextstart(2) <= scale(4)
            if ~any(all(nextstart == temppath, 2)) && ~any(all(nextstart == obstancle, 2))
                path = searchpathdfs(path, length-1, nextstart, target, scale, [temppath; nextstart], obstancle);
            end
        end
    end
end
    
end

