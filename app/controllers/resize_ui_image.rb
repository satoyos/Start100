# transported code in the page
# http://stackoverflow.com/questions/6141298/how-to-scale-down-a-uiimage-and-make-it-crispy-sharp-at-the-same-time-instead

module ResizeUIImage
  def self.resizeImage(image, newSize:newSize)
    newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height))
    imageRef = image.CGImage
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    context = UIGraphicsGetCurrentContext()

    # Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, KCGInterpolationHigh)
    flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);

    return flipVertical
    #%Todo: ↑CGAffineTransformが返るようになった！ので、続きから！
  end
end