import imageio
import glob
import re


def create_gif(image_list, gif_name):
    frames = []
    
    print("Creating gif file...")
    
    for image_name in image_list:
        print("File   - " + image_name)
        frames.append(imageio.imread(image_name))
        
    print("")
    print("Saving  - " + gif_name)
    
    # Save them as frames into a gif
    kargs = { 'duration': 0.1, 'fps': 1 }
    imageio.mimsave(gif_name, frames, 'GIF', **kargs)
    
    print("Saved  - " + gif_name)
    print("")
    print("Done.")
    
    return




def find_all_png():
    png_filenames = glob.glob("./*.png")
    png_filenames.sort()
    
    print("Found " + str(len(png_filenames)) + " file(s):")
    for png_file in png_filenames:
        if not png_file.endswith("_pressed.png"):
            print("  - " + png_file)
    print("")
    
    buf=[]
    for png_file in png_filenames:
        if not png_file.endswith("_pressed.png"):
            buf.append(png_file)
    
    return buf





if __name__ == '__main__':
    buff = find_all_png()
    create_gif(buff, 'created_gif.gif')





