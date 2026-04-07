# Video Labeling Tool

A lightweight tool for manually labeling actions in video files. You can mark specific frames and assign an action class to each one. Both a **MATLAB GUI version** and a **Python CLI version** are provided.

---

## Features

- Browse and play `.avi` video files
- Pause playback to assign an action label to the current frame
- Navigate forward and backward through the video
- Save labels to a file for later use
- Skip already-labeled videos (Python version)

---

## Requirements

### MATLAB version
- MATLAB (tested with R2019a or later)
- MATLAB GUIDE (included with standard MATLAB)

### Python version
- Python 3.x
- [OpenCV](https://pypi.org/project/opencv-python/) (`cv2`)
- NumPy

Install Python dependencies:
```bash
pip install opencv-python numpy
```

---

## Usage

### MATLAB version (`Label.m` + `Label.fig`)

1. Open MATLAB and navigate to the repository folder.
2. Run `Label` in the MATLAB command window to launch the GUI.
3. Click **Browse** (or press `B`) to select a `.avi` or `.mp4` video file.
4. Press **Play** (or `Space`) to start playback.
5. Press **Space** again to pause and enter a label.
6. Type the label number in the text box and click **Add** (or press the corresponding number key).
7. Press **S** to save the labels to a `.mat` file with the same name as the video.

#### MATLAB keyboard shortcuts

| Key | Action |
|-----|--------|
| `Space` | Play / Pause |
| `←` / `→` | Seek backward / forward (~1%) |
| `B` | Browse for a video file |
| `P` | Open the next video file in the same folder |
| `S` | Save labels |
| `E` | Jump to the end of the video |
| `1`–`5` | Quick-add label 1–5 while paused |

#### MATLAB output format

Labels are saved as a `.mat` file (e.g., `Class3_000001.mat`) containing:
- `label` – vector of action class IDs
- `fr` – vector of frame numbers corresponding to each label

---

### Python version (`Python_label_video.py`)

The script recursively scans a directory for `.avi` files and lets you label them one by one.

1. Edit the last line of `Python_label_video.py` to point to your video directory:
   ```python
   label("your_video_directory")
   ```
2. Run the script:
   ```bash
   python Python_label_video.py
   ```
3. A window will open showing the video. Use the keys below to navigate and label frames.
4. Labels are saved automatically to a `Thanh_Labels/` folder when a video finishes. Already-labeled videos are skipped.

#### Python keyboard shortcuts

| Key | Action |
|-----|--------|
| `Space` | Pause and enter a label for the current frame |
| `K` | Seek backward 2 seconds |
| `L` | Seek forward 2 seconds |

After pressing `Space`, type the action number in the terminal:

| Number | Action |
|--------|--------|
| `1` | Sitting up |
| `2` | Lying down |
| `3` | Neutral → Left |
| `4` | Left → Neutral |
| `5` | Neutral → Right |
| `6` | Right → Neutral |
| `7` | Head move back |

#### Python output format

Labels are saved as plain text files in the `Thanh_Labels/` directory. Each row corresponds to one labeled event:

```
<action_id>  <start_time_s>  <end_time_s>  <start_frame>  <end_frame>
```

The end time is `start + 5 seconds` and the end frame is `start + 150 frames`.

---

## Customization

Both versions are designed as starting points. Feel free to modify the source code to add new action classes, change the output format, or adapt the tool to your own dataset.

---

## License

This project is open source. Contributions and adaptations are welcome.
