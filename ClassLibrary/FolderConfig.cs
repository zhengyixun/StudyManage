using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using ZhClass;

namespace STU
{
    /// <summary>
    /// FolderConfig 的摘要说明
    /// </summary>
    public class FolderConfig : ZhFolderConfig
    {
        #region 从上传临时目录改名并移到正式目录
        /// <summary>
        /// 从上传临时目录改名并移到正式目录
        /// </summary>
        /// <returns></returns>
        /// <param name="oldimg">原文件,仅文件名</param>
        /// <param name="img">新文件,仅文件名</param>
        /// <param name="Officialpath">正式目录,仅目录名</param>
        /// <param name="delold">true-删除原文件; false-不删;</param>
        public static string MoveFile(string oldimg, string img, string Officialpath, bool delold, Action<string, string> func = null)
        {
            string source = Config.folder.UpLoad.MapPath();
            string dest = Officialpath.MapPath() + "\\";
            if (!System.IO.Directory.Exists(dest)) //检查目录是否存在,若不存在则必须创建,否则会报错
                System.IO.Directory.CreateDirectory(dest);

            if (img == "")
                return oldimg;
            if (oldimg == img)
                return oldimg;
            else
            {
                if (delold && !oldimg.IsNullOrEmpty()) //要求删除老的,并且老文件不为空,这样要删
                    System.IO.File.Delete(dest + oldimg);
                return string.Join(",", img.Split(':').Distinct().Select(t =>
                {
                    string tmp = DateTime.Now.ToString("yyyyMMddHHmmssfff") + System.IO.Path.GetExtension(t); // ".jpg"
                    try
                    {
                        System.IO.File.Move(source + t, dest + tmp);
                        if (func != null)
                            func(dest, tmp);
                        //ZhImg.Thumbnail(dest + tmp, 230, 1000, System.Drawing.Color.Empty, dest);
                    } //将文件移到HotelImg目录下并改名
                    catch { }
                    System.Threading.Thread.Sleep(5);
                    return tmp;
                }));
            }
        }
        /// <summary>
        /// 从上传临时目录移到正式目录,并按要求改名
        /// </summary>
        /// <param name="oldimg">上传目录下的文件,仅文件名</param>
        /// <param name="newimg">实际文件,仅文件名</param>
        /// <param name="Officialpath">实际目录,仅目录名</param>
        /// <param name="func">移动后事件</param>
        /// <returns></returns>
        public static bool MoveFile(string oldimg, string newimg, string Officialpath, Action<string, string> func = null)
        {
            string source = Config.folder.UpLoad.MapPath();
            string dest = Officialpath.MapPath() + "\\";
            if (!System.IO.Directory.Exists(dest)) //检查目录是否存在,若不存在则必须创建,否则会报错
                System.IO.Directory.CreateDirectory(dest);

            try
            {
                System.IO.File.Move(source + oldimg, dest + newimg);
                if (func != null)
                    func(dest, newimg);
                return true;
            }
            catch(Exception e) { ZH.SaveErr(e.toString()); return false; }
        }
        #endregion

        #region 导出文件目录
        [ConfigurationProperty("export", IsRequired = true)]
        ZhConfigElement export
        {
            get { return (ZhConfigElement)this["export"]; }
        }
        public string Export
        {
            get { return export.Value; }
        }
        #endregion
    }
}