# data_entry_gui.py
# Copied on 2023-03-05 from https://datatofish.com/entry-box-tkinter/

import tkinter as tk

root = tk.Tk()

canvas1 = tk.Canvas(root, width=400, height=300)
canvas1.pack()

entry1 = tk.Entry(root)
canvas1.create_window(200, 140, window=entry1)

def get_square_root():
    x1 = entry1.get()

    label1 = tk.Label(root, text=float(x1)**0.5)
    canvas1.create_window(200, 230, window=label1)

button1 = tk.Button(text='Get the square root', command=get_square_root)
canvas1.create_window(200, 180, window=button1)

root.mainloop()


