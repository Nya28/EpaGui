function varargout = replace(varargin)
% replace M-file for replace.fig
%      replace, by itself, creates a new replace or raises the existing
%      singleton*.
%
%      H = replace returns the handle to a new replace or the handle to
%      the existing singleton*.
%
%      replace('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in replace.M with the given input arguments.
%
%      replace('Property','Value',...) creates a new replace or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EPANET_Functions_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to replace_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help replace

% Last Modified by GUIDE v2.5 16-Mar-2012 08:15:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @replace_OpeningFcn, ...
                   'gui_OutputFcn',  @replace_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before replace is made visible.
function replace_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to replace (see VARARGIN)

% Choose default command line output for lbox2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.figure1,'name','Epanet2.dll');

initial_dir=varargin{3};

% Populate the listbox
typefile=varargin{1};
load_listbox(initial_dir,handles,typefile)
% Return figure handle as first output argument
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes lbox2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

allfileIn =(get(handles.listbox1,'String'));

w = length(allfileIn);
i=1;
handles.name=varargin{2};
guidata(hObject, handles);

while i<w+1
    v = strcmp(allfileIn(i),handles.name);
    if v==1
       msg = ReplaceQu;%function ReplaceQu GUI
       r = strcmp(msg,'Yes');
       if r ==1
           handles.yes=1;
           guidata(hObject, handles);

       else
           handles.yes=0;
           guidata(hObject, handles);

           return
       end
    end
    
    i=i+1;
end

if w==0
    handles.yes=2;
    guidata(hObject, handles);

    return
end

 handles.yes=2; %ok , saving
 guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = replace_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

varargout = {handles.yes};

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

get(handles.figure1,'SelectionType');
if strcmp(get(handles.figure1,'SelectionType'),'open')
    index_selected = get(handles.listbox1,'Value');
    file_list = get(handles.listbox1,'String');
    filename = file_list{index_selected};
    if  handles.is_dir(handles.sorted_index(index_selected))
        cd (filename)
        load_listbox(pwd,handles)
    else
        [path,name,ext,ver] = fileparts(filename);
        switch ext
            case '.fig'
                guide (filename)
            otherwise
                try
                    open(filename)
                catch
                    errordlg(lasterr,'File Type Error','modal')
                end
        end
    end
end
% ------------------------------------------------------------
% Read the current directory and sort the names
% ------------------------------------------------------------
function load_listbox(dir_path,handles,typefile)
%cd (dir_path)
dir_struct = dir(strcat(dir_path,char(typefile)));
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = sorted_index;
guidata(handles.figure1,handles)
set(handles.listbox1,'String',handles.file_names,...
	'Value',1)
% set(handles.text1,'String',pwd)

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


