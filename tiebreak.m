weight_fix = round(weight);
temp_fillmap = vec_fillmap.' * weight_fix;
temp_fillmap = temp_fillmap + ~fill_without_num_1(:);

empty_region = bwlabel(reshape(~temp_fillmap,[total_row,total_col]),4);
vec_empty_region = empty_region(:).';

for ii = 1:max(vec_empty_region)
    [empty_region_row, empty_region_col] = find(empty_region == ii);
    empty_id = sort(find(any((puzzle_row == empty_region_row.') & (puzzle_col == empty_region_col.'),2)));
    if isempty(empty_id)
        continue
    end

    match_pos = (vec_empty_region == ii);
    waitlist = all(match_pos - vec_fillmap >= 0, 2);
    %
    waitlist(weight<1e-3) = 0;
    ind = find(waitlist);
    
    temp_min_value = sum(match_pos);
    temp_ind_best = [];
    
    for jj = 1:max_iter
        temp_match_pos = match_pos;
        temp_ind = ind(randperm(length(ind)));
        temp_ind_selected = [];
        
        for kk = 1:length(temp_ind)
            if all(temp_match_pos - vec_fillmap(temp_ind(kk),:) >=0)
                temp_match_pos = temp_match_pos - vec_fillmap(temp_ind(kk),:);
                temp_ind_selected = [temp_ind_selected temp_ind(kk)];%#ok
            end
            if all(temp_match_pos == 0)
                break
            end
        end
        
        temp_value = sum(temp_match_pos);
        if temp_value < temp_min_value
            temp_min_value = temp_value;
            temp_ind_best = temp_ind_selected;
        end
        
        if temp_min_value == 0
            weight_fix(temp_ind_best) = 1;
            break
        elseif jj == max_iter
            weight_fix(temp_ind_best) = 1;
        end
        
    end
end

weight_fix = (weight_fix == 1);
