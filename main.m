clear;
filename = 'data_32_32_tokyotower';
load(filename);

puzzle_num = puzzledata(:,1);
puzzle_color = puzzledata(:,2);
puzzle_row = puzzledata(:,3);
puzzle_col = puzzledata(:,4);

endpointmap = zeros(total_row, total_col);
endpointmap(sub2ind([total_row, total_col], puzzle_row, puzzle_col)) = 1;

fill_without_num_1 = ones(total_row, total_col);
fill_without_num_1(sub2ind([total_row, total_col], puzzle_row(puzzle_num==1), puzzle_col(puzzle_num==1))) = 0;

% draw puzzle
fontsize = round(300/total_row);
colorfillmap = zeros(total_row, total_col);
colorfillmap(sub2ind([total_row, total_col], puzzle_row, puzzle_col)) = puzzle_color;%#ok
numfillmap = zeros(total_row, total_col);
numfillmap(sub2ind([total_row, total_col], puzzle_row, puzzle_col)) = puzzle_num;
plotpuzzle;
drawnow;

%tic();

%% Find Feasible Paths
% divide points into sets
unique_num_color_pair = unique([puzzle_num, puzzle_color],'rows');
unique_num_color_pair(unique_num_color_pair(:,1) == 1, :) = [];
n_sets = size(unique_num_color_pair, 1);
puzzle_set_id = zeros(length(puzzle_num), 1);
for ii = 1:n_sets
   puzzle_set_id(all([puzzle_num, puzzle_color] == unique_num_color_pair(ii,:), 2)) = ii;
end

% generate all feasible paths
path_lookup = {};
vec_fillmap = [];
vec_fillmap_set_id = [];
vec_fillmap_pair_id = [];

for ii = 1:n_sets
    num = unique_num_color_pair(ii, 1);
    temp_row = puzzle_row(puzzle_set_id == ii);
    temp_col = puzzle_col(puzzle_set_id == ii);
    temp_path = [];
    temp_vec_fillmap = [];
    n_endpoint = length(temp_row);
    endpoint_pairs = nchoosek(1:n_endpoint,2);
    for jj = 1:nchoosek(n_endpoint,2)
        start = [temp_row(endpoint_pairs(jj,1)) temp_col(endpoint_pairs(jj,1))];
        target = [temp_row(endpoint_pairs(jj,2)) temp_col(endpoint_pairs(jj,2))];
        [new_path, new_vec_fillmap] = findpath(start, target, num-1, puzzle_row, puzzle_col, total_row, total_col);
        if ~isempty(new_vec_fillmap)
            path_lookup = [path_lookup; new_path.'];%#ok
            temp_vec_fillmap = [temp_vec_fillmap; new_vec_fillmap];%#ok
            %vec_fillmap_pair_id = [vec_fillmap_pair_id; repmat(sort([id1, id2]), numel(new_path), 1)];%#ok
        end
    end
    vec_fillmap = [vec_fillmap; temp_vec_fillmap];%#ok
    vec_fillmap_set_id = [vec_fillmap_set_id; ii*ones(size(temp_vec_fillmap,1), 1)];%#ok
end

%% solve linear programming problem
m = total_row * total_col;
n = size(vec_fillmap, 1);

cvx_begin
    variable diff_fillmap(m)
    variable weight(n)
    variable fillmap(m)
    minimize sum(diff_fillmap)
    subject to
        fillmap == vec_fillmap.' * weight %#ok
        -diff_fillmap <= fillmap - fill_without_num_1(:) <= diff_fillmap %#ok
        0 <= weight <= 1 %#ok
        if strcmp(filename(1:6),'data_e') % For derivative puzzles
            for ii = 1:n_sets
                sum(weight(vec_fillmap_set_id == ii)) <= sum(puzzle_set_id == ii) / 2; %#ok
            end
        end
cvx_end

%% Draw results
weight_fix = round(weight);
max_iter = 10000;
tiebreak;

%toc();

temp_color = unique_num_color_pair(:,2);
colorfillmap = (vec_fillmap.* temp_color(vec_fillmap_set_id)).' * weight_fix;
colorfillmap = reshape(colorfillmap, total_row, total_col);
colorfillmap(sub2ind([total_row, total_col], puzzle_row, puzzle_col)) = puzzle_color;
plotresult;
