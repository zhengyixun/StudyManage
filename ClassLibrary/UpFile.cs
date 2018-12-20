using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Web;

namespace STU
{
    public class UpFile : IHttpHandler
    {
        string file, bg, type;
        int width, height;
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            try
            {
                HttpFileCollection uploadedFiles = context.Request.Files;
                HttpPostedFile F = uploadedFiles[0];
                if (F != null)
                {
                    string FileName = Guid.NewGuid().ToString("N") + System.IO.Path.GetExtension(F.FileName); //F.FileName;
                    file = STU.Config.folder.UpLoad.MapPath() + "\\" + FileName;
                    F.SaveAs(file);
                    width = context.Request.Form["maxwidth"].toString(0);
                    height = context.Request.Form["maxheight"].toString(0);
                    bg = context.Request.Form["background"].toString();
                    type = context.Request.Form["type"].toString().ToLower();

                    //ZhClass.ZH.SaveErr(F.FileName + "-,-" + context.Request.Form["type"]);
                    switch (type)
                    {
                        case "image/jpeg":
                            Thumbnail();
                            break;
                        case "image/png":
                            Thumbnail();
                            break;
                    }
                    context.Response.Write(string.Format(@"{{""filename"":""{0}""}}", FileName));
                }
                else
                    context.Response.Write(@"{""filename"":""""}");
            }
            catch (Exception e) { ZhClass.ZH.SaveErr(e.toString()); }
        }
        void Thumbnail()
        {
            string filename = System.IO.Path.GetFileNameWithoutExtension(file); //拿到没有后缀的文件名

            if (width > 0 && height > 0)
            {
                int ActualWidth = 0;  //图片实际宽度
                int ActualHeight = 0; //图片实际高度
                int Srcx = 0;         //图片左边距
                int Srcy = 0;         //图片上边距

                Image newImg;
                using (Image oriImg = Image.FromFile(file))
                {
                    if ((width < oriImg.Width) || (height < oriImg.Height)) //执行按比例缩小
                    {
                        if (width.toString(0f) / height.toString(0f) > oriImg.Width.toString(0f) / oriImg.Height.toString(0f)) //以高度为准计算
                        {
                            ActualWidth = height * oriImg.Width / oriImg.Height;
                            ActualHeight = height;
                            Srcx = (width - ActualWidth) / 2;
                        }
                        else
                        {
                            ActualWidth = width;
                            ActualHeight = width * oriImg.Height / oriImg.Width;
                            Srcy = (height - ActualHeight) / 2;
                        }
                    }
                    else
                    {
                        ActualWidth = oriImg.Width;
                        ActualHeight = oriImg.Height;
                        Srcx = (width - ActualWidth) / 2;
                        Srcy = (height - ActualHeight) / 2;
                    } //以上操作完成后,得到缩图的宽与高,下面生成缩图,并保存到缩图文件夹                

                    //根据颜色判断是否产生固定大小的缩图
                    newImg = bg.IsNullOrEmpty() ? new Bitmap(ActualWidth, ActualHeight) : new Bitmap(width, height);
                    using (Graphics g = Graphics.FromImage(newImg)) //把新图形加载进Graphice对象中
                    {
                        if (!bg.IsNullOrEmpty())
                            g.Clear(ColorTranslator.FromHtml("#" + bg)); //声明背景色
                        else
                        {
                            Srcx = 0;
                            Srcy = 0;
                        }

                        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                        g.InterpolationMode = InterpolationMode.HighQualityBicubic; //指定高质量插值法,关键在于HighQualityBicubic
                        g.DrawImage(oriImg, new Rectangle(Srcx, Srcy, ActualWidth, ActualHeight), 0, 0, oriImg.Width, oriImg.Height, GraphicsUnit.Pixel);
                    }
                } //到这里，源图，画板均可以释放了
                switch (type)
                {
                    case "image/jpeg":
                        newImg.Save(file, ImageFormat.Jpeg);
                        file.compressJPG();
                        break;
                    case "image/gif": //这个永远也走不到
                        newImg.Save(file, ImageFormat.Gif);
                        break;
                    case "image/png":
                        newImg.Save(file, ImageFormat.Png);
                        file.compressPNG();
                        break;
                    default: //这个永远也走不到
                        newImg.Save(file, ImageFormat.Jpeg);
                        break;
                }
                newImg.Dispose();
            }
        }

        public bool IsReusable { get { return false; } }
    }
}
