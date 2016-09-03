@time using CVCore,CVVideoIO,CVImgProc,CVHighGUI,Cxx
cap = VideoCapture(0)
frame = Mat{UInt8}()

grad = Mat{UInt8}()
grad_x, abs_grad_x= Mat{UInt8}(),Mat{UInt8}()
grad_y, abs_grad_y= Mat{UInt8}(),Mat{UInt8}()

try
    while true
        ok = read!(cap, frame); !ok && continue
        h, w = size(frame)

        # 適当な画像処理
        img = resize(frame, (w/2,h/2))
        GaussianBlur!(img, img, CVCore.cvSize(3,3), 0, 0)
        gray = cvtColor(img, COLOR_BGR2GRAY)
        Sobel!(gray, grad_x, CV_16S, 1, 0)
        convertScaleAbs!(grad_x, abs_grad_x)
        Sobel!(gray, grad_y, CV_16S, 0, 1)
        convertScaleAbs!(grad_y, abs_grad_y)
        addWeighted!(abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad)

        imshow("img", img)
        imshow("grad", grad)

        key = waitKey(1)
        key == 27 && break

        if key == Int('s')
            imwrite("img.png", img)
            imwrite("grad.png", grad)
        end
        rand() > 0.97 && gc(false)
    end
finally
    close(cap)
    destroyAllWindows()
end
cap=0;frame=0;gc()
