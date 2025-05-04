s = serial('com9');
        fopen(s);
        fwrite(s,'AA');
        pause(2);
fwrite(s,'AA');
        pause(2);
        fclose(s);
        clear s