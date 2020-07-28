import sys
import cv2

if __name__ == '__main__':
    source = sys.argv[1]
    target = sys.argv[2]
    img = cv2.imread(source)
    cv2.imwrite(target, img)
