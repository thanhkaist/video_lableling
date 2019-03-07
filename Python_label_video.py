import os
import cv2
import sys
#import ipdb
import numpy as np
import glob

def label(video_dpath):
    files = [f for f in glob.iglob(video_dpath+"/**/*.avi",recursive=True)]; L = len(files)
    for i, video_fpath in enumerate(files):
        label = []
        print("Processing video: " + video_fpath + " ({}/{})".format(i+1,L))
        cap = cv2.VideoCapture(video_fpath);
        s = video_fpath.replace('/','_');
        if os.path.exists("Thanh_Labels/" + s+"_label.txt"):
            print("This label already existed, go to next!")
            continue;
        while cap.isOpened():
            ok, frame = cap.read()
            #s = video_fpath.replace('/','_');
            if not ok:
                print("Video completed!");
                if not os.path.exists("Thanh_Labels"):
                    os.makedirs("Thanh_Labels")
                np.savetxt("Thanh_Labels/" + s+"_label.txt",label,fmt="%s")
                break;
            if ok:
                cv2.imshow('img', frame);
                key_pressed = cv2.waitKey(33)&0xFF; #check pressed key
                current_timestamp = cap.get(cv2.CAP_PROP_POS_MSEC);
                print(key_pressed)
                if key_pressed == 32: # SPACE
                    timestamp = cap.get(cv2.CAP_PROP_POS_MSEC)
                    frame = cap.get(cv2.CAP_PROP_POS_FRAMES)
                    sec = timestamp / 1000
                    print("Label [1: sitting up, 2: lying down, 3: Neu-> Left, 4: Left -> Neu, 5.Neu-> Right 6.Right-> Neu 7. Head Move Back]: ")
                    action = cv2.waitKey(0)&0xFF - 48
                    print ("Labeled at {:.2f}s: {}".format(sec, action))
                    label.append([str(int(action)), sec, sec+5, frame, frame+150]) #action duration = 5s
                if key_pressed == 107:
                    print("Back 2s")
                    cap.set(cv2.CAP_PROP_POS_MSEC, current_timestamp-2000) #back 2s
                if key_pressed == 108:
                    print("Next 2s")
                    cap.set(cv2.CAP_PROP_POS_MSEC, current_timestamp+2000) #next 2s
    print("Completed videos:" + " ({}/{})".format(i+1,L))
    print("Please send me files in folder Labels, thank for your support!")
if __name__ == "__main__":
    label("Class3")
