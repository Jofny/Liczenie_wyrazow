close all; clear; clc;

[y, fs] = audioread("wypowiedz.mp3");
numDataPoints = numel(y);
minDist = floor(numDataPoints / 8);
[pks, locs] = findpeaks(y(:, 1), 'MinPeakHeight', 0.15, 'MinPeakDistance', minDist, 'NPeaks', 6);
start_times = locs/fs;
fundamental = 240;
note_names = {'Maciej', 'Jan'};
colors = {'yellow', 'green'};

x = y';
N = length(x);
t = (0 : N-1)/fs;
plot(t,x);
hold on;
for i=1:length(start_times)
    note = y(round(start_times(i)*fs):round((start_times(i)+0.5)*fs));
    note_fft = abs(fft(note));
    [max_val, max_idx] = max(note_fft);
    if max_val < fundamental
        idx=2;
    else
        idx=1;
    end
    note_name = note_names{idx};
    color = colors{idx};
    plot([start_times(i), start_times(i)], [1, -1], color);
    text(start_times(i), 0.8, note_name);
    hold on;
    fprintf('Nuta %d: %s\n', i, note_name);  
    disp(max_val);
end



%%
[y, fs] = audioread("wypowiedz.mp3");
y=y(start_times(2)*fs:start_times(3)*fs);
envelope = imdilate(abs(y), true(5000, 1));
quietParts = envelope > 0.01;
beginning1 = strfind(quietParts',[0 1]);
ending1 = strfind(quietParts', [1 0]);

plot(y)
hold on;
for i=1:length(ending1)
    if i <= length(ending1)
        plot([ending1(i), ending1(i)], [1, -1], 'red');
        hold on;
    end
    if i <= length(beginning1)
        plot([beginning1(i), beginning1(i)], [1, -1], 'red');
        hold on;
    end
end
display(start_times(2));
display(start_times(3));

%%
[y, fs] = audioread("wypowiedz.mp3");
y=y(start_times(4)*fs:start_times(5)*fs);
envelope = imdilate(abs(y), true(5000, 1));
quietParts = envelope > 0.01;
beginning2 = strfind(quietParts',[0 1]);
ending2 = strfind(quietParts', [1 0]);

plot(y)
hold on;
for i=1:length(ending2)
    if i <= length(ending2)
        plot([ending2(i), ending2(i)], [1, -1], 'red');
        hold on;
    end
    if i <= length(beginning2)
        plot([beginning2(i), beginning2(i)], [1, -1], 'red');
        hold on;
    end
end
display(start_times(4));
display(start_times(5));
%%
[y, fs] = audioread("wypowiedz.mp3");
y=y(start_times(6)*fs:end);
envelope = imdilate(abs(y), true(5000, 1));
quietParts = envelope > 0.01;
beginning3 = strfind(quietParts',[0 1]);
ending3 = strfind(quietParts', [1 0]);

plot(y)
hold on;
for i=1:length(ending3)
    if i <= length(ending3)
        plot([ending3(i), ending3(i)], [1, -1], 'red');
        hold on;
    end
    if i <= length(beginning3)
        plot([beginning3(i), beginning3(i)], [1, -1], 'red');
        hold on;
    end
end
display(start_times(6));
display(start_times(6)+length(y)/fs);
%%
prawdziwa_ilosc = [17 16 17];
zliczona_ilosc = [length(beginning1) length(beginning2) length(beginning3)];
blad1 = (abs(prawdziwa_ilosc(1) - zliczona_ilosc(1)) / prawdziwa_ilosc(1));
blad2 = (abs(prawdziwa_ilosc(2) - zliczona_ilosc(2)) / prawdziwa_ilosc(2));
blad3 = (abs(prawdziwa_ilosc(3) - zliczona_ilosc(3)) / prawdziwa_ilosc(3));
sredni_blad = (blad1+blad2+blad3) / 3;

fprintf("Błąd dla pierwszego kawałka tekstu: %f \n", blad1);
fprintf("Błąd dla drugiego kawałka tekstu: %f \n", blad2);
fprintf("Błąd dla trzeciego kawałka tekstu: %f \n", blad3);
fprintf("Średni błąd dla wszystkich kawałków tekstu: %f \n", sredni_blad);