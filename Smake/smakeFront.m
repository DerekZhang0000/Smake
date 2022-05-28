function varargout = smakeFront(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @smakeFront_OpeningFcn, ...
                   'gui_OutputFcn',  @smakeFront_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function smakeFront_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = smakeFront_OutputFcn(hObject, eventdata, handles)

function startButton_Callback(hObject, eventdata, handles)
    handles.output = hObject;
    axes(handles.display);
    global smakeX smakeY curDirection;
    [smakeX, smakeY, appleX, appleY, curDirection] = newGame();
    pause(.1);
    while(true)
        [smakeX, smakeY, appleX, appleY] = updateSmakeDirection(smakeX, smakeY, appleX, appleY, curDirection);
        pause(.1);
        if (isDead(smakeX, smakeY))
            break;
        end
    end

varargout{1} = handles.output;

function upButton_Callback(hObject, eventdata, handles)
    global curDirection;
    if ~strcmp(curDirection, "Down")
        curDirection = "Up";
    end

function leftButton_Callback(hObject, eventdata, handles)
    global curDirection;
    if ~strcmp(curDirection, "Right")
        curDirection = "Left";
    end

function downButton_Callback(hObject, eventdata, handles)
    global curDirection;
    if ~strcmp(curDirection, "Up")
        curDirection = "Down";
    end

function rightButton_Callback(hObject, eventdata, handles)
    global curDirection;
    if ~strcmp(curDirection, "Left")
        curDirection = "Right";
    end

function [smakeX, smakeY, appleX, appleY, curDirection] = newGame()
    global redMatrix greenMatrix blueMatrix;
    redMatrix = 0 * ones(50, 50);
    greenMatrix = 255 * ones(50, 50);
    blueMatrix = 255 * ones(50, 50);
    smakeX = [23, 24, 25, 26, 27];
    smakeY = [25, 25, 25, 25, 25];
    redMatrix(smakeY(1) + 1, smakeX(1) + 1) = 100;
    greenMatrix(smakeY(1) + 1, smakeX(1) + 1) = 180;
    blueMatrix(smakeY(1) + 1, smakeX(1) + 1) = 0;
    for i = 2:1:length(smakeX)
        redMatrix(smakeY(i) + 1, smakeX(i) + 1) = 100;
        greenMatrix(smakeY(i) + 1, smakeX(i) + 1) = 220;
        blueMatrix(smakeY(i) + 1, smakeX(i) + 1) = 0;
    end
    curDirection = "Left";
    [appleX, appleY] = spawnApple(smakeY, smakeX);
    redMatrix(appleY, appleX) = 255;
    blueMatrix(appleY, appleX) = 0;
    greenMatrix(appleY, appleX) = 0;
    imshow(uint8(cat(3, redMatrix, greenMatrix, blueMatrix)));

function [smakeX, smakeY, appleX, appleY] = updateSmakeDirection(smakeX, smakeY, appleX, appleY, curDirection)
    global redMatrix greenMatrix blueMatrix
    redMatrix = 0 * ones(50, 50);
    greenMatrix = 255 * ones(50, 50);
    blueMatrix = 255 * ones(50, 50);
    redMatrix(appleY, appleX) = 255;
    greenMatrix(appleY, appleX) = 0;
    blueMatrix(appleY, appleX) = 0;
    if strcmp(curDirection, "Up")
        smakeY = [smakeY(1) - 1, smakeY(1:end)];
        smakeX = [smakeX(1), smakeX(1:end)];
        if isDead(smakeX, smakeY)
            return;
        elseif ~ateApple(smakeY(1), smakeX(1))
            smakeX(end) = [];
            smakeY(end) = [];
        else
            [appleX, appleY] = spawnApple(smakeY, smakeX);
        end
    elseif strcmp(curDirection, "Down")
        smakeY = [smakeY(1) + 1, smakeY(1:end)];
        smakeX = [smakeX(1), smakeX(1:end)];
        if isDead(smakeX, smakeY)
            return;
        elseif ~ateApple(smakeY(1), smakeX(1))
            smakeX(end) = [];
            smakeY(end) = [];
        else
            [appleX, appleY] = spawnApple(smakeY, smakeX);
        end
    elseif strcmp(curDirection, "Left")
        smakeY = [smakeY(1), smakeY(1:end)];
        smakeX = [smakeX(1) - 1, smakeX(1:end)];
        if isDead(smakeX, smakeY)
            return;
        elseif ~ateApple(smakeY(1), smakeX(1))
            smakeX(end) = [];
            smakeY(end) = [];
        else
            [appleX, appleY] = spawnApple(smakeY, smakeX);
        end
    elseif strcmp(curDirection, "Right")
        smakeY = [smakeY(1), smakeY(1:end)];
        smakeX = [smakeX(1) + 1, smakeX(1:end)];
        if isDead(smakeX, smakeY)
            return;
        elseif ~ateApple(smakeY(1), smakeX(1))
            smakeX(end) = [];
            smakeY(end) = [];
        else
            [appleX, appleY] = spawnApple(smakeY, smakeX);
        end
    end
    redMatrix(smakeY(1) + 1, smakeX(1) + 1) = 100;
    greenMatrix(smakeY(1) + 1, smakeX(1) + 1) = 180;
    blueMatrix(smakeY(1) + 1, smakeX(1) + 1) = 0;
    for i = 2:1:length(smakeX)
        blueMatrix(smakeY(i) + 1, smakeX(i) + 1) = 0;
        greenMatrix(smakeY(i) + 1, smakeX(i) + 1) = 220;
        redMatrix(smakeY(i) + 1, smakeX(i) + 1) = 100;
    end
    redMatrix(appleY, appleX) = 255;
    greenMatrix(appleY, appleX) = 0;
    blueMatrix(appleY, appleX) = 0;
    imshow(uint8(cat(3, redMatrix, greenMatrix, blueMatrix)));

function [ateApple] = ateApple(headY, headX)
    global redMatrix;
    if redMatrix(headY + 1, headX + 1) == 255
        ateApple = true;
    else
        ateApple = false;
    end

function [isDead] = isDead(smakeX, smakeY)
    if min(smakeX) < 0 || max(smakeX) > 49 || min(smakeY) < 0 || max(smakeY) > 49
        isDead = true;
    elseif intersectSelf(smakeX, smakeY)
        isDead = true;
    else
        isDead = false;
    end

function [intersectSelf] = intersectSelf(smakeX, smakeY)
    segments = [smakeX; smakeY]';
    if length(unique(segments, 'rows', 'first')) == length(segments)
        intersectSelf = false;
    else
        intersectSelf = true;
    end

function [appleX, appleY] = spawnApple(smakeY, smakeX)
    appleX = randi([1, 50]);
    appleY = randi([1, 50]);
    while (ismember([appleY appleX], [(smakeY + 1); (smakeX + 1)]', 'rows'))
        appleX = randi([1, 50]);
        appleY = randi([1, 50]);
    end
