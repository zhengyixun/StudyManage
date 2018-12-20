using System;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.RegularExpressions;

/// <summary>
/// Extensions 的摘要说明
/// </summary>
public static class myExtensions
{
    public static string sizeToString(this long fileSize)
    {
        if (fileSize / 1024 < 1024)
            return (fileSize / 1024).toString() + "Kb";
        else if (fileSize / 1024 / 1024 < 1024)
            return (fileSize / 1024 / 1024.0).ToString("0.00") + "Mb";
        else
            return (fileSize / 1024 / 1024 / 1024.0).ToString("0.00") + "Gb";
    }
    public static string FromtalSeconds(this int second)
    {
        if (second <= 0)
            return "";
        TimeSpan ts = new TimeSpan(0, 0, second);
        System.Text.StringBuilder sb = new System.Text.StringBuilder("(");
        sb.AppendFormat("{0}:{1})", ts.Minutes.ToString("00"), ts.Seconds.ToString("00"));
        if (ts.Hours > 0)
            sb.Insert(1, ts.Hours.ToString("00") + ":");
        if (ts.Days > 0)
            sb.Insert(1, ts.Days + "天 ");
        return sb.ToString();
    }
    public static string FileMD5(this string pathName)
    {
        try
        {
            if (System.IO.File.Exists(pathName))
                return pathName.getFileMD5();
            else
                return "";
        }
        catch
        { return ""; }
    }

    #region 数字随机码
    public static string RandowNum(this int n)
    {
        Char[] s = new Char[] { '2', '3', '4', '5', '6', '7', '8', '9', '1', '0' };
        StringBuilder num = new StringBuilder();
        System.Random r = new System.Random();
        for (int i = 0; i < n; i++)
            num.Append(s[r.Next(0, s.Length)].ToString());
        return num.ToString();
    }
    #endregion


    public static byte[] getFileToZip(this string url)
    {
        return File.ReadAllBytes(url).Zip();
    }

    public static string replaceBlank(this string str)
    {
        String result = str;
        if (str != null)
        {
            result = Regex.Replace(result, @"\s*|\t|\r|\n", "", RegexOptions.IgnoreCase);
            result = Regex.Replace(result, @"&nbsp;", "", RegexOptions.IgnoreCase);
            result = Regex.Replace(result, "（", "(", RegexOptions.IgnoreCase);
            result = Regex.Replace(result, "）", ")", RegexOptions.IgnoreCase);
        }
        return result;
    }

    #region 获取内容中的第一个图片
    public static string getFirstImg(this string msg)
    {
        if (msg.IndexOf("<img") > -1)
        {
            var reg = new Regex(@"\<img(.*?)src\=""(.*?)""(.*?)\/\>", RegexOptions.IgnoreCase).Match(msg);
            return reg.Success ? reg.Result("$2") : "";
        }
        return "";
    }
    #endregion

    #region 获取远程文件源码
    public static string GetSourCode(this string url)
    {
        try
        {
            HttpWebRequest reqHttpWeb = (HttpWebRequest)WebRequest.Create(url);
            StreamReader responseReader = new StreamReader(reqHttpWeb.GetResponse().GetResponseStream(), System.Text.Encoding.UTF8);
            return responseReader.ReadToEnd();
        }
        catch { return ""; }
    }
    #endregion
    #region 获取POST数据返回值
    public static string Post(this string data, string url)
    {
        try
        {
            HttpWebRequest reqHttpWeb = (HttpWebRequest)WebRequest.Create(url);
            byte[] requestBytes = System.Text.Encoding.UTF8.GetBytes(data);

            reqHttpWeb.Method = "POST";
            reqHttpWeb.ContentType = "application/x-www-form-urlencoded";
            reqHttpWeb.ContentLength = requestBytes.Length;
            reqHttpWeb.ServicePoint.Expect100Continue = false;
            reqHttpWeb.Timeout = 5000;

            using (Stream requestStream = reqHttpWeb.GetRequestStream())
            {
                requestStream.Write(requestBytes, 0, requestBytes.Length);
                using (HttpWebResponse resHttpWeb = (HttpWebResponse)reqHttpWeb.GetResponse())
                {
                    //using (StreamReader sReader = new StreamReader(resHttpWeb.GetResponseStream(), System.Text.Encoding.GetEncoding("gb2312")))
                    using (StreamReader sReader = new StreamReader(resHttpWeb.GetResponseStream(), System.Text.Encoding.UTF8))
                    {
                        var bytes = default(byte[]);
                        using (var memstream = new MemoryStream())
                        {
                            sReader.BaseStream.CopyTo(memstream);
                            bytes = memstream.ToArray();
                        }
                        if (bytes.Length <= 0)
                            return "";
                        else
                            return Encoding.UTF8.GetString(bytes); //sReader.ReadToEnd(); 
                    }
                }
            }
        }
        catch { return ""; }
    }
    #endregion
    

    #region 获取hash1字符串
    public static string GetHashString(this string inputString)
    {
        StringBuilder sb = new StringBuilder();
        foreach (byte b in GetHash(inputString))
            sb.Append(b.ToString("X2"));

        return sb.ToString();
    }
    static byte[] GetHash(string inputString)
    {
        HashAlgorithm algorithm = SHA1.Create();  // SHA1.Create()
        return algorithm.ComputeHash(Encoding.UTF8.GetBytes(inputString));
    }
    #endregion


    public static string jsRequest(this string str)
    {
        return str.getRequest().IsNullOrEmpty().ToString().ToLower();
    }
}