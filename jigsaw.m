
function jigsaw()
%% 主函数
    Tag_A = Disrupt();%将标记矩阵的排列顺序打乱
    drawmap(Tag_A);%按照标记矩阵显示拼图
    tic
    global Tag;%Tag是标记矩阵，定义成全局变量，方便传递参数
    Tag=Tag_A;
    set(gcf,'windowButtonDownFcn', @ButtonDownFcn);%点击鼠标时调用ButtonDownFcn函数
 
function ButtonDownFcn(src,event)
%% 回调函数，鼠标点击事件发生时调用
    pt=get(gca,'CurrentPoint');%获取当前鼠标点击位置坐标
    xpos=pt(1,1);%鼠标点击处的横坐标实际值
    ypos=pt(1,2);%鼠标点击处的纵坐标实际值

    col = ceil(xpos/100);%将横坐标值转换为列数
    row = ceil(ypos/100);%将纵坐标值转换为行数

    global Tag; %全局变量声明

    if(col <= 3 && col >0)&&(row <= 3&&row > 0)%鼠标点击位置在有效范围内    
        Tag=movejig(Tag,row,col);%按点击位置移动拼图

        drawmap(Tag)%显示拼图

        order = [1 2 3;4 5 6;7 8 0];%顺序矩阵
        zt = abs(Tag-order);%比较两个矩阵
        if sum(zt(:)) == 0 %顺序已经完全吻合
            image = imread('jigsawImage.jpeg');
            imshow(image) %游戏完成，补全拼图
            tStr = toc
            msg = ['恭喜完成! 用时', num2str(tStr), '秒']
            msgbox(msg) %提示完成信息

            pause(2);%延迟2秒
            close all %游戏结束，关闭所有图像窗口
        end

    else
        return
    end
 
function tag = movejig(tag, row, col)
%% 4个if分4种情况对不同位置处的点坐标与矩阵行列式统一
    num = tag(row,col);%鼠标位置与号码牌一致
    if (row > 1)&&(tag(row-1,col)==0)%点击位置在第二或第三行，空白块在点击位置的上一行
        tag(row-1,col) = num;%交换两个位置上的值
        tag(row,col) = 0;
    end
    if (row < 3)&&(tag(row+1,col)==0)%点击位置在第一或第二行，空白块在点击位置的下一行
        tag(row+1,col) = num;
        tag(row,col) = 0;
    end
    if (col > 1)&&(tag(row,col-1)==0)%点击位置在第二或第三列，空白块在点击位置的左边一列
        tag(row,col-1) = num;
        tag(row,col) = 0;
    end
    if (col < 3)&&(tag(row,col+1)==0)%点击位置在第二或第三列，空白块在点击位置的右边一列
        tag(row,col+1) = num;
        tag(row,col) = 0;
    end
 
function y = Disrupt()
%% 随机打乱原拼图排列顺序
    y =[1,2,3; 4,5,6; 7,8,0];

    for i = 1:400
        row = randi([1,3]);%产生一个范围在1到3的整数
        col = randi([1,3]);
        y = movejig(y, row, col);%按随机产生的动作打乱拼图
    end
 
function x = choose(image,index)
%% 根据索引选择对应位置上的拼图块
    if index > 0 %标记为1，2，3，4，5，6，7，8的拼图块
        % 计算出行数row以及列数column
        row = fix((index - 1) / 3);
        column = mod(index - 1, 3);
        % 分割出对应拼图块数据
        x = image(1 + row * 100 : 100 * (row + 1), 1 + column * 100 : 100 * (column + 1), : );
    else
        x=uint8(255*ones(100,100,3));%拼图块0矩阵数据
    end

function drawmap(A)
%% 将运算数字与对应拼图对应显示图片
    origin=imread('jigsawImage.jpeg');
    image=origin;

    % 对要显示的拼图进行赋值
    for row=1:3
        for col=1:3
        image(1 + (row - 1) * 100 : 100 * row, 1 + (col - 1) * 100 : 100 * col, : ) = choose(origin, A(row , col));
        end
    end
    imshow(image)%显示拼图

    
