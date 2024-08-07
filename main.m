function jigsaw()
% 主函数
Tag_A = Disrupt();  % 将标记矩阵的排列顺序打乱
drawmap(Tag_A);     % 按照标记矩阵显示拼图
tic;                % 开始计时
global Tag;         % Tag 是标记矩阵，定义成全局变量，方便传递参数
Tag = Tag_A;
set(gcf, 'windowButtonDownFcn', @ButtonDownFcn);    % 点击鼠标时调用 ButtonDownFcn 函数

function ButtonDownFcn(~, ~)
% 回调函数，鼠标点击事件发生时调用
pt = get(gca, 'CurrentPoint');  % 获取当前鼠标点击位置坐标
xpos = pt(1, 1);   % 鼠标点击处的横坐标实际值
ypos = pt(1, 2);   % 鼠标点击处的纵坐标实际值

col = ceil(xpos/60);   % 将横坐标值转换为列数
row = ceil(ypos/60);   % 将纵坐标值转换为行数

global Tag; % 全局变量声明

if(col <= 5 && col >= 1)&&(row <= 5&&row >= 1)  % 鼠标点击位置在有效范围内
    Tag = movejig(Tag, row, col);   % 按点击位置移动拼图
    
    drawmap(Tag)    % 显示拼图
    
    data = 1:25;
    matrix_10x10 = reshape(data, 5, 5);
    matrix_10x10(end, end) = 0;
    order = matrix_10x10';  %˳原始顺序矩阵
    zt = abs(Tag - order);  % 比较两个矩阵
    if sum(zt(:)) == 0      %˳顺序已经完全吻合
        image = imread('Naruse-Shiroha.jpg');
        imshow(image) % 游戏完成，补全拼图
        tStr = toc;   % 结束计时
        msg = ['恭喜完成! 用时', num2str(tStr), '秒'];
        msgbox(msg)  % 提示完成信息
        
        pause(2);    % 延迟 2 秒
        close all    % 游戏结束，关闭所有图像窗口
    end
    
else
    return
end

function tag = movejig(tag, row, col)
% 4 个 if 分 4 种情况对不同位置处的点坐标与矩阵行列式统一
num = tag(row, col);
if (row > 1)&&(tag(row-1, col)==0)
    tag(row-1,col) = num;
    tag(row,col) = 0;
end
if (row < 5)&&(tag(row+1, col)==0)
    tag(row+1,col) = num;
    tag(row,col) = 0;
end
if (col > 1)&&(tag(row, col-1)==0)
    tag(row,col-1) = num;
    tag(row,col) = 0;
end
if (col < 5)&&(tag(row, col+1)==0)
    tag(row,col+1) = num;
    tag(row,col) = 0;
end

function y = Disrupt()
% 随机打乱原拼图排列顺序
data = 1:25;
matrix_10x10 = reshape(data, 5, 5);
matrix_10x10(end, end) = 0;
y = matrix_10x10';

for i = 1:800
    row = randi([1, 5]);
    col = randi([1, 5]);
    y = movejig(y, row, col);
end

function x = choose(image, index)
% 根据索引选择对应位置上的拼图块，image 是原图的数据矩阵，index 是要选择的拼图块编号
if index > 0
    row = fix((index - 1)/5);    % fix 表示向零取整
    column = mod(index - 1, 5);  %
    x = image(1 + row * 60 : 60 * (row + 1), 1 + column * 60 : 60 * (column + 1), : );
else
    x = uint8(255*ones(60, 60, 3));
end

function drawmap(A)
origin = imread('Naruse-Shiroha.jpg');
image = origin;

for row = 1:5
    for col = 1:5
        image(1 + (row - 1) * 60 : 60 * row, 1 + (col - 1) * 60 : 60 * col, : ) = choose(origin, A(row , col));
    end
end
imshow(image)

