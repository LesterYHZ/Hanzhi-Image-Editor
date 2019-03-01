classdef Hanzhi_Image_Editor < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        File                    matlab.ui.container.Menu
        Open                    matlab.ui.container.Menu
        Save                    matlab.ui.container.Menu
        Exit                    matlab.ui.container.Menu
        Tool                    matlab.ui.container.Menu
        Basic_Adjust            matlab.ui.container.Menu
        Contrast                matlab.ui.container.Menu
        Crop                    matlab.ui.container.Menu
        Rotate                  matlab.ui.container.Menu
        Enhance                 matlab.ui.container.Menu
        ASCII                   matlab.ui.container.Menu
        Preset                  matlab.ui.container.Menu
        Sketch                  matlab.ui.container.Menu
        Anime                   matlab.ui.container.Menu
        Analysis                matlab.ui.container.Menu
        Histogram               matlab.ui.container.Menu
        Ha                      matlab.ui.container.Menu
        Zhangzhe                matlab.ui.container.Menu
        Image_Axes              matlab.ui.control.UIAxes
        Contrast_Slider         matlab.ui.control.Slider
        Contrast_Confirm        matlab.ui.control.Button
        Contrast_Spinner        matlab.ui.control.Spinner
        Contrast_Cancel         matlab.ui.control.Button
        Contrast_ReverseButton  matlab.ui.control.StateButton
    end

% /**
%  *������������������������������+ +
%  *�������������������ߩ��������ߩ� + +
%  *�������������������������������� ��
%  *�������������������������������� ++ + + +
%  *������������ ������������������ ��+
%  *�������������������������������� +
%  *�����������������������ߡ�������
%  *�������������������������������� + +
%  *��������������������������������
%  *��������������������������������������������������
%  *���������������������������� + + + +
%  *������������������������������������Code is far away from bug with the animal protecting��������������
%  *���������������������������� + �����������ޱ���,������bug����
%  *����������������������������
%  *��������������������������������+������������������
%  *���������������������� �������������� + +
%  *�������������������� ���������������ǩ�
%  *�������������������� ������������������
%  *�����������������������������ש����� + + + +
%  *�����������������������ϩϡ����ϩ�
%  *�����������������������ߩ������ߩ�+ + + +
%  */

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            set(app.Image_Axes,'Visible','off');
            set(app.Contrast_Slider,'Visible','off');
            set(app.Contrast_Spinner,'Visible','off');
            set(app.Contrast_Confirm,'Visible','off');
            set(app.Contrast_Cancel,'Visible','off');
            set(app.Contrast_ReverseButton,'Visible','off');
            
            set(app.Save,'Enable','off');
            set(app.Tool,'Enable','off');
            set(app.Analysis,'Enable','off');
            set(app.Preset,'Enable','off');
            
            set(app.Image_Axes,'Position',[1,1,836,573]);
        end

        % Menu selected function: Open
        function OpenMenuSelected(app, ~)
            % ���ļ�����ѡȡ�ļ�
            [filename,pathname] = uigetfile(...
                {'*.bmp;*.jpg;*.png;*.jpeg',...
                'Image Files (*.bmp,*.jpg,*.png,*.jpeg)';...
                '*.*',...
                'All Files (*.*)'},...
                'Pick an image');
            % �����ȡ����ֱ���˳�
            if isequal(filename,0) || isequal(pathname,0)
                return;
            end
            
            % ��ʾͼƬ����
            set(app.Image_Axes,'Visible','on');
            
            % ����ͼ��༭����
            set(app.Save,'Enable','on');
            set(app.Tool,'Enable','on');
            set(app.Analysis,'Enable','on');
            set(app.Preset,'Enable','on');
            
            % ��ȡͼƬ����ʾ
            fpath=[pathname filename];
            img_src=imread(fpath);
            setappdata(app.UIFigure,'img_src',img_src);     % ��ͼƬ���󱣴�Ϊapp����
            setappdata(app.UIFigure,'file',fpath);
            imshow(img_src,'Parent',app.Image_Axes);
        end

        % Menu selected function: Zhangzhe
        function ZhangzheMenuSelected(app, ~)
           %% �¸��µ�ǹ������ͷһ�������㡾����������
            
            % ��ȡ����ͷ��
            img_src=imread('Source\Zemin.bmp');
            imshow(img_src,'Parent',app.Image_Axes);
            setappdata(app.UIFigure,'img_src',img_src);     % ��ͼƬ���󱣴�Ϊapp����
            setappdata(app.UIFigure,'file','Source/Zemin.bmp');
            
            % ����ͼ��༭����
            set(app.Save,'Enable','on');
            set(app.Tool,'Enable','on');
            set(app.Analysis,'Enable','on');
            set(app.Preset,'Enable','on');
        end

        % Menu selected function: Save
        function SaveMenuSelected(app, ~)
            % ���ļ����洰��
            [filename,pathname]=uiputfile(...
                {'*.bmp','BMP files';...
                '*.jpg;','JPG files';...
                '*.png;','PNG files'},...
                'Pick an Image');
            if isequal(filename,0) || isequal(pathname,0)
                return; % ������ˡ�ȡ����
            else
                fpath=fullfile(pathname,filename); % ���ȫ·������һ�ַ���
            end
            
            img_src = getappdata(app.UIFigure,'img_src');
            imwrite(img_src,fpath);
            
            %             % ֪ͨ�û�����ɹ�
            %             % ���Կ���ɾ���������
            %             msgbox('Sucessfully Saved!','Yeah!');
            %             uiwait();
        end

        % Menu selected function: Exit
        function ExitMenuSelected(~, ~)
            % �رմ���
            closereq;
        end

        % Menu selected function: Enhance
        function EnhanceMenuSelected(app, ~)
            % ����������
            f = waitbar(0,'ͼƬ�����С���');
            pause(0.5);
            waitbar(0.6,f,'����ˣ���');
            pause(1);
            waitbar(0.99,f,'���1%��Զ�������ġ�������');
            
            % ����RF�Ӻ���
            opacity=50;
            L=128;
            img_src = getappdata(app.UIFigure,'img_src');
            I = double(img_src);
            H = RF(I,30,100)-I+L;
            G = imfilter(H,fspecial('gaussian',[3 3],100));
            Dest = (I*(100-opacity)+(I+2*G-256)*opacity)/100;
            imshow(uint8(Dest),'Parent',app.Image_Axes);
            
            % �رջ���������
            delete(f);
            
            % ѯ���Ƿ���ĥƤ����
            ButtonName = questdlg('Wanna keep the change?',...
                ' ',...
                'Yes','No',...
                'Yes');
            switch ButtonName
                case 'Yes'
                    setappdata(app.UIFigure,'img_src',uint8(Dest));
                case 'No'
                    imshow(img_src,'Parent',app.Image_Axes);
                    return;
            end
            
        end

        % Menu selected function: ASCII
        function ASCIIMenuSelected(app, ~)
            % ��ȡ�ļ���ַ
            file = getappdata(app.UIFigure,'file');
            % ����txt�ļ�
            txt = img2txt(file);
            
            % �����ļ�
            [filename,pathname]=uiputfile(...
                {'*.txt','Text File'},...
                'Save');
            if isequal(filename,0) || isequal(pathname,0)
                return; % ������ˡ�ȡ����
            else
                fpath=fullfile(pathname,filename); % ���ȫ·������һ�ַ���
            end
            % �ļ�д��
            fid = fopen(fpath,'w');
            siz = size(txt);
            for a=1:siz(1)
                fwrite(fid,[txt(a,:),13,10]);
            end
            % �ر��ļ�
            fclose(fid);
            
            %             % ������Ϣ����ɾ��
            %             msgbox('Complete!');
            %             uiwait();
            
            % �ⲿ���ļ�
            winopen(fpath);
            
            %             ButtonName = questdlg('Do you need a preview?','Question','Yes','No','Yes');
            %             switch ButtonName
            %                 case 'Yes'
            %                     disp(txt);
            %                     set(hObject,'Visible','off');
            %                     set(handles.Button_Save','Visible','on');
            %                     setappdata(handles.Main_Figure,'txt',txt);
            %                 case 'No'
            %                     set(hObject,'Visible','off');
            %                     set(handles.Button_Save','Visible','on');
            %                     setappdata(handles.Main_Figure,'txt',txt);
            %             end
        end

        % Menu selected function: Sketch
        function SketchMenuSelected(app, ~)
            %% Ŀǰʹ��Ԥ��threshold���պ�������slider
            
            white_threshold = 40;
            
            img = getappdata(app.UIFigure,'img_src');
%             img_src = uint8(double(img_src) .* 1.5);
            
            % ����������
            f = waitbar(0,'ͼƬ�����С���');
            pause(.5);
            waitbar(0.6,f,'����ˣ���');
            pause(1);
            waitbar(0.99,f,'���1%��Զ�������ġ�������');
            
            % �����Ӻ�����forѭ��һ��������ر���)
            img = convert2Sketch(img, white_threshold);
            % �رջ���������
            delete(f);
            % ��ʾ���н��
            imshow(img,'Parent',app.Image_Axes);
            
            % ѯ���Ƿ���������
            ButtonName = questdlg('Wanna keep the change?',...
                ' ',...
                'Yes','No',...
                'Yes');
            switch ButtonName
                case 'Yes'
                    setappdata(app.UIFigure,'img_src',img);
                case 'No'
                    imshow(getappdata(app.UIFigure,'img_src'),'Parent',app.Image_Axes);
                    return;
            end
        end

        % Menu selected function: Anime
        function AnimeMenuSelected(app, ~)
            img = getappdata(app.UIFigure,'img_src');
%             img_src = uint8(double(img_src) .* 1.5);
            
            % ����������
            f = waitbar(0,'ͼƬ�����С���');
            pause(0.5);
            waitbar(0.6,f,'����ˣ���');
            pause(1);
            waitbar(0.99,f,'���1%��Զ�������ġ�������');
            
            % �����Ӻ���
            img = convert2Anime(img);
            % �رջ���������
            delete(f);
            % ��ʾ���н��
            imshow(img,'Parent',app.Image_Axes);
            
            % ѯ���Ƿ���������
            ButtonName = questdlg('Wanna keep the change?',...
                ' ',...
                'Yes','No',...
                'Yes');
            switch ButtonName
                case 'Yes'
                    setappdata(app.UIFigure,'img_src',img);
                case 'No'
                    imshow(getappdata(app.UIFigure,'img_src'),'Parent',app.Image_Axes);
                    return;
            end
        end

        % Menu selected function: Histogram
        function HistogramMenuSelected(app, ~)
            figure('Name','Histogram');
            
            im = getappdata(app.UIFigure,'img_src');
            % Plot the histograms
            subplot(3,1,1);
            histogram(im(:,:,1), 'FaceColor', [1 0 0], 'EdgeColor', 'none');
            subplot(3,1,2);
            histogram(im(:,:,2), 'FaceColor', [0 1 0], 'EdgeColor', 'none');
            subplot(3,1,3);
            histogram(im(:,:,3), 'FaceColor', [0 0 1], 'EdgeColor', 'none');
            
            
        end

        % Menu selected function: Crop
        function CropMenuSelected(app, ~)

            img_src = getappdata(app.UIFigure,'img_src');
            
            img = imcrop(img_src);
            setappdata(app.UIFigure,'img_changed',img);
            close;
            imshow(img,'Parent',app.Image_Axes);
            
            % ѯ���Ƿ���������
            ButtonName = questdlg('Wanna keep the change?',...
                ' ',...
                'Yes','No',...
                'Yes');
            switch ButtonName
                case 'Yes'
                    setappdata(app.UIFigure,'img_src',img);
                case 'No'
                    imshow(getappdata(app.UIFigure,'img_src'),'Parent',app.Image_Axes);
                    return;
            end
        end

        % Menu selected function: Contrast
        function ContrastMenuSelected(app, ~)
            set(app.Image_Axes,'Position',[135,1,702,573]);
            set(app.Contrast_Slider,'Visible','on');
            set(app.Contrast_Spinner,'Visible','on');
            set(app.Contrast_Confirm,'Visible','on');
            set(app.Contrast_Cancel,'Visible','on');
            set(app.Contrast_ReverseButton,'Visible','on');
            
            set(app.Contrast_Slider,'Value',0);
            set(app.Contrast_Spinner,'Value',0);
            set(app.Contrast_ReverseButton,'Value',0);
            set(app.Contrast_ReverseButton,'Text','��');
            setappdata(app.UIFigure,'ContrastSliderValue',0);
            setappdata(app.UIFigure,'ContrastSpinnerValue',0);
        end

        % Button pushed function: Contrast_Confirm
        function Contrast_ConfirmButtonPushed(app, ~)
            img = getappdata(app.UIFigure,'img_changed');
            setappdata(app.UIFigure,'img_src',img);
            imshow(img,'Parent',app.Image_Axes);
            
            set(app.Contrast_Slider,'Visible','off');
            set(app.Contrast_Spinner,'Visible','off');
            set(app.Contrast_Confirm,'Visible','off');
            set(app.Contrast_Cancel,'Visible','off');
            set(app.Contrast_ReverseButton,'Visible','off');
            set(app.Image_Axes,'Position',[1,1,836,573]);
        end

        % Button pushed function: Contrast_Cancel
        function Contrast_CancelButtonPushed(app, ~)
            img_src = getappdata(app.UIFigure,'img_src');
            imshow(img_src,'Parent',app.Image_Axes);
            
            set(app.Contrast_Slider,'Visible','off');
            set(app.Contrast_Spinner,'Visible','off');
            set(app.Contrast_Confirm,'Visible','off');
            set(app.Contrast_Cancel,'Visible','off');
            set(app.Contrast_ReverseButton,'Visible','off');
            set(app.Image_Axes,'Position',[1,1,836,573]);
        end

        % Value changing function: Contrast_Slider
        function Contrast_SliderValueChanging(app, event)
            Cont = event.Value;
            set(app.Contrast_Spinner,'Value',round(Cont));
            setappdata(app.UIFigure,'ContrastSliderValue',Cont);
            setappdata(app.UIFigure,'ContrastSpinnerValue',Cont);
            
            if app.Contrast_ReverseButton.Value == 1
                img = getappdata(app.UIFigure,'img_src');
                img = imadjust(img,[0,Cont/100]);
                imshow(img,'Parent',app.Image_Axes);
                setappdata(app.UIFigure,'img_changed',img);
            else
                img = getappdata(app.UIFigure,'img_src');
                img = imadjust(img,[Cont/100,1]);
                imshow(img,'Parent',app.Image_Axes);
                setappdata(app.UIFigure,'img_changed',img);
            end
        end

        % Value changed function: Contrast_Spinner
        function Contrast_SpinnerValueChanged(app, ~)
            Cont = app.Contrast_Spinner.Value;
            set(app.Contrast_Slider,'Value',Cont);
            setappdata(app.UIFigure,'ContrastSliderValue',Cont);
            setappdata(app.UIFigure,'ContrastSpinnerValue',Cont);
            
            if app.Contrast_ReverseButton == 1
                img = getappdata(app.UIFigure,'img_src');
                img = imadjust(img,[0,Cont/100]);
                imshow(img,'Parent',app.Image_Axes);
                setappdata(app.UIFigure,'img_changed',img);
            else
                img = getappdata(app.UIFigure,'img_src');
                img = imadjust(img,[Cont/100,1]);
                imshow(img,'Parent',app.Image_Axes);
                setappdata(app.UIFigure,'img_changed',img);
            end
        end

        % Value changed function: Contrast_ReverseButton
        function Contrast_ReverseButtonValueChanged(app, ~)
            value = app.Contrast_ReverseButton.Value;
            
            if value
                app.Contrast_ReverseButton.Text = '��';
                app.Contrast_Slider.Value = getappdata(app.UIFigure,'ContrastSliderValue');
                app.Contrast_Spinner.Value = getappdata(app.UIFigure,'ContrastSpinnerValue');
            else
                app.Contrast_ReverseButton.Text = '��';
                app.Contrast_Slider.Value = getappdata(app.UIFigure,'ContrastSliderValue');
                app.Contrast_Spinner.Value = getappdata(app.UIFigure,'ContrastSpinnerValue');
            end
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 836 573];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.Resize = 'off';

            % Create File
            app.File = uimenu(app.UIFigure);
            app.File.Text = '�ļ�';

            % Create Open
            app.Open = uimenu(app.File);
            app.Open.MenuSelectedFcn = createCallbackFcn(app, @OpenMenuSelected, true);
            app.Open.Accelerator = 'O';
            app.Open.Text = '��';

            % Create Save
            app.Save = uimenu(app.File);
            app.Save.MenuSelectedFcn = createCallbackFcn(app, @SaveMenuSelected, true);
            app.Save.Accelerator = 's';
            app.Save.Text = '����';

            % Create Exit
            app.Exit = uimenu(app.File);
            app.Exit.MenuSelectedFcn = createCallbackFcn(app, @ExitMenuSelected, true);
            app.Exit.Separator = 'on';
            app.Exit.Text = '�˳�';

            % Create Tool
            app.Tool = uimenu(app.UIFigure);
            app.Tool.Text = '����';

            % Create Basic_Adjust
            app.Basic_Adjust = uimenu(app.Tool);
            app.Basic_Adjust.Text = '��������';

            % Create Contrast
            app.Contrast = uimenu(app.Basic_Adjust);
            app.Contrast.MenuSelectedFcn = createCallbackFcn(app, @ContrastMenuSelected, true);
            app.Contrast.Text = '�Աȶ�';

            % Create Crop
            app.Crop = uimenu(app.Tool);
            app.Crop.MenuSelectedFcn = createCallbackFcn(app, @CropMenuSelected, true);
            app.Crop.Text = '�ü�';

            % Create Rotate
            app.Rotate = uimenu(app.Tool);
            app.Rotate.Enable = 'off';
            app.Rotate.Text = '��ת';

            % Create Enhance
            app.Enhance = uimenu(app.Tool);
            app.Enhance.MenuSelectedFcn = createCallbackFcn(app, @EnhanceMenuSelected, true);
            app.Enhance.Separator = 'on';
            app.Enhance.Text = 'һ��ĥƤ';

            % Create ASCII
            app.ASCII = uimenu(app.Tool);
            app.ASCII.MenuSelectedFcn = createCallbackFcn(app, @ASCIIMenuSelected, true);
            app.ASCII.Text = 'һ��ASCII��';

            % Create Preset
            app.Preset = uimenu(app.UIFigure);
            app.Preset.Text = '���';

            % Create Sketch
            app.Sketch = uimenu(app.Preset);
            app.Sketch.MenuSelectedFcn = createCallbackFcn(app, @SketchMenuSelected, true);
            app.Sketch.Text = '����';

            % Create Anime
            app.Anime = uimenu(app.Preset);
            app.Anime.MenuSelectedFcn = createCallbackFcn(app, @AnimeMenuSelected, true);
            app.Anime.Text = '����';

            % Create Analysis
            app.Analysis = uimenu(app.UIFigure);
            app.Analysis.Text = '����';

            % Create Histogram
            app.Histogram = uimenu(app.Analysis);
            app.Histogram.MenuSelectedFcn = createCallbackFcn(app, @HistogramMenuSelected, true);
            app.Histogram.Text = 'ֱ��ͼ';

            % Create Ha
            app.Ha = uimenu(app.UIFigure);
            app.Ha.Text = '���';

            % Create Zhangzhe
            app.Zhangzhe = uimenu(app.Ha);
            app.Zhangzhe.MenuSelectedFcn = createCallbackFcn(app, @ZhangzheMenuSelected, true);
            app.Zhangzhe.Text = '��Ϊ������һ��';

            % Create Image_Axes
            app.Image_Axes = uiaxes(app.UIFigure);
            app.Image_Axes.PlotBoxAspectRatio = [1 0.75 0.75];
            app.Image_Axes.FontSize = 1;
            app.Image_Axes.TitleFontWeight = 'bold';
            app.Image_Axes.Position = [135 1 702 573];

            % Create Contrast_Slider
            app.Contrast_Slider = uislider(app.UIFigure);
            app.Contrast_Slider.Orientation = 'vertical';
            app.Contrast_Slider.ValueChangingFcn = createCallbackFcn(app, @Contrast_SliderValueChanging, true);
            app.Contrast_Slider.Visible = 'off';
            app.Contrast_Slider.Position = [50 102 3 386];

            % Create Contrast_Spinner
            app.Contrast_Spinner = uispinner(app.UIFigure);
            app.Contrast_Spinner.Limits = [0 100];
            app.Contrast_Spinner.ValueChangedFcn = createCallbackFcn(app, @Contrast_SpinnerValueChanged, true);
            app.Contrast_Spinner.Visible = 'off';
            app.Contrast_Spinner.Position = [19 519 66 22];

            % Create Contrast_Confirm
            app.Contrast_Confirm = uibutton(app.UIFigure, 'push');
            app.Contrast_Confirm.ButtonPushedFcn = createCallbackFcn(app, @Contrast_ConfirmButtonPushed, true);
            app.Contrast_Confirm.Visible = 'off';
            app.Contrast_Confirm.Position = [19 63 100 25];
            app.Contrast_Confirm.Text = 'ȷ��';

            % Create Contrast_Cancel
            app.Contrast_Cancel = uibutton(app.UIFigure, 'push');
            app.Contrast_Cancel.ButtonPushedFcn = createCallbackFcn(app, @Contrast_CancelButtonPushed, true);
            app.Contrast_Cancel.Visible = 'off';
            app.Contrast_Cancel.Position = [19 30 100 26];
            app.Contrast_Cancel.Text = 'ȡ��';

            % Create Contrast_ReverseButton
            app.Contrast_ReverseButton = uibutton(app.UIFigure, 'state');
            app.Contrast_ReverseButton.ValueChangedFcn = createCallbackFcn(app, @Contrast_ReverseButtonValueChanged, true);
            app.Contrast_ReverseButton.Visible = 'off';
            app.Contrast_ReverseButton.Text = '��';
            app.Contrast_ReverseButton.Position = [91 516 30 25];
        end
    end

    methods (Access = public)

        % Construct app
        function app = Hanzhi_Image_Editor

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end