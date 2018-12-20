using System;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Net;
using ZhClass;

namespace STU
{
    public class WXDownMedia
    {
        string access_token, media_id, dir, filetype; //学校ID,素材ID,存储目录,文件类型
        string downpath, lastpath, img_name;//拿下来的本地路径,最终的文件全路径，图片则去掉了_tmp，音频的话则是mp3,最终的文件名
        bool thumbnail, tomp3;//要不要缩图,是否要转mp3
        int t_w, t_h; //缩图的大小

        public WXDownMedia(string _access_token, string _media_id, string _dir, string _filetype, bool _thumbnail, int _t_w, int _t_h, bool _tomp3)
        {
            //ZH.SaveErr(string.Format("_school_id:{0}, _access_token:{1}, _media_id:{2}, _dir:{3}, _filetype:{4}, _thumbnail:{5}, _t_w:{6}, _t_h:{7}, _tomp3:{8}", _school_id, _access_token, _media_id, _dir, _filetype, _thumbnail, _t_w, _t_h, _tomp3));
            access_token = _access_token;
            media_id = _media_id;
            dir = _dir;
            filetype = _filetype;
            thumbnail = _thumbnail;
            t_w = _t_w;
            t_h = _t_h;
            tomp3 = _tomp3;

            string filename = DateTime.Now.ToString("yyyyMMddHHmmssfff");
            switch (filetype)
            {
                case "img":
                    downpath = string.Format(@"{0}\{1}{2}.png", dir, filename, (thumbnail ? "_tmp" : ""));
                    lastpath = string.Format(@"{0}\{1}.png", dir, filename);
                    img_name = string.Format(@"{0}.png", filename);
                    break;
                case "voice":
                    downpath = string.Format(@"{0}\{1}.amr", dir, filename);
                    lastpath = string.Format(@"{0}\{1}.{2}", dir, filename, tomp3 ? "mp3" : "amr");
                    img_name = string.Format(@"{0}.{1}", filename, tomp3 ? "mp3" : "amr");
                    break;
            }
        }

        public bool Save()
        {
            SqlPar par = new SqlPar() { Sql = "insert into wximgs (school_id,media_id,dir,filetype,thumbnail,t_w,t_h,tomp3) values (@school_id,@media_id,@dir,@filetype,@thumbnail,@t_w,@t_h,@tomp3)" };
            par.SetParValues("", this.media_id, this.dir, this.filetype, this.thumbnail ? 1 : 0, this.t_w, this.t_h, this.tomp3 ? 1 : 0);
            return DB.ExeSql(par) > 0;
        }

        public string Down()
        {
            if (access_token.IsNullOrEmpty()) return "";
            if (!Save()) return "";

            string file = string.Format(@"http://file.api.weixin.qq.com/cgi-bin/media/get?access_token={0}&media_id={1}", access_token, media_id);
            //ZH.SaveErr(file);
            try
            {
                HttpWebRequest reqHttpWeb = (HttpWebRequest)WebRequest.Create(file);
                reqHttpWeb.Timeout = 5000;

                using (HttpWebResponse resHttpWeb = (HttpWebResponse)reqHttpWeb.GetResponse())
                {
                    if (resHttpWeb.ContentType == "application/json; encoding=utf-8")
                    {
                        using (StreamReader responseReader = new StreamReader(reqHttpWeb.GetResponse().GetResponseStream(), System.Text.Encoding.UTF8))
                        {
                            upDataErr(responseReader.ReadToEnd()); //下载失败
                            return "";
                        }
                    }

                    using (StreamReader sReader = new StreamReader(resHttpWeb.GetResponseStream(), System.Text.Encoding.UTF8))
                    {
                        using (var memstream = new MemoryStream())
                        {
                            sReader.BaseStream.CopyTo(memstream);
                            System.IO.File.WriteAllBytes(downpath, memstream.ToArray()); //写入到硬盘上

                            switch (filetype)
                            {
                                case "img":
                                    if (thumbnail && t_w > 0 && t_h > 0)
                                    {
                                        int ActualWidth = 0;  //图片实际宽度
                                        int ActualHeight = 0; //图片实际高度

                                        try
                                        {
                                            using (System.Drawing.Image oriImg = System.Drawing.Image.FromFile(downpath))
                                            {
                                                if ((t_w < oriImg.Width) && (t_h < oriImg.Height)) //两个都过了,才缩,否则不用动
                                                {
                                                    //都应以长边为准,若以短边为准,必然存在留白
                                                    ActualWidth = t_w;
                                                    ActualHeight = oriImg.Height * t_w / oriImg.Width;
                                                }
                                                else
                                                {
                                                    ActualWidth = oriImg.Width;
                                                    ActualHeight = oriImg.Height;
                                                }
                                                using (System.Drawing.Image newImg = new Bitmap(ActualWidth, ActualHeight))
                                                {
                                                    using (Graphics g = Graphics.FromImage(newImg)) //把新图形加载进Graphice对象中
                                                    {
                                                        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                                                        g.InterpolationMode = InterpolationMode.HighQualityBicubic; //指定高质量插值法,关键在于HighQualityBicubic
                                                        g.DrawImage(oriImg, new Rectangle(0, 0, ActualWidth, ActualHeight), 0, 0, oriImg.Width, oriImg.Height, GraphicsUnit.Pixel);

                                                        newImg.Save(lastpath, ImageFormat.Png);
                                                        lastpath.compressPNG(); //压缩下png
                                                    }
                                                }
                                            }
                                            System.IO.File.Delete(downpath);
                                            return upData();//更新数据库
                                        }
                                        catch (Exception ex)
                                        {
                                            ZH.SaveErr(string.Format("生成缩图时出错,文件名:{0}\r\n{1}", downpath, ex.ToString()));
                                        }
                                    }
                                    return upData();//更新数据库
                                case "voice":
                                    if (tomp3)
                                    {
                                        try
                                        {
                                            ProcessStartInfo oInfo = new ProcessStartInfo(AppDomain.CurrentDomain.BaseDirectory + "/ffmpeg.exe", string.Format(@"-i {0} {1}", downpath, lastpath));

                                            oInfo.UseShellExecute = false;
                                            oInfo.CreateNoWindow = true;
                                            oInfo.RedirectStandardOutput = false;
                                            oInfo.RedirectStandardError = true;

                                            Process proc = new Process();
                                            proc.StartInfo = oInfo;

                                            //Hook up events
                                            proc.EnableRaisingEvents = true;
                                            //proc.ErrorDataReceived += (pes, pee) => CS.Config.SaveErr(string.Format(@"转换文件 {0} 时出错,出错内容:{1}", amr, pee.toString()));
                                            proc.Exited += (ps, pe) =>
                                            {
                                                int iExitCode = proc.ExitCode;
                                                bool blFileExists = File.Exists(lastpath);
                                                if (iExitCode.Equals(0) && blFileExists) //转换成功,文件已生成,删掉原文件
                                                    File.Delete(downpath);
                                                proc.Close();
                                            };

                                            proc.Start();
                                            proc.BeginErrorReadLine();

                                            return upData();//更新数据库
                                        }
                                        catch (Exception ex)
                                        {
                                            ZH.SaveErr("转换为MP3格式时出错:" + ex.ToString());
                                        }
                                    }
                                    return upData();//更新数据库
                                default: return "";
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {
                ZH.SaveErr(e.ToString());
                return "";
            }
        }

        string upData()
        {
            SqlPar par = new SqlPar() { Sql = "delete wximgs where media_id=@media_id" };
            par.SetParValues(this.media_id);
            DB.ExeSql(par);
            return this.img_name;
        }
        void upDataErr(string errStr)
        {
            SqlPar par = new SqlPar() { Sql = "update wximgs set err=@err,errNum+=1 where media_id=@media_id" };
            par.SetParValues(errStr, this.media_id);
            DB.ExeSql(par);
        }
    }
}
