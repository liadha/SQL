using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.DevTools.V109.Page;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Amazon
{
    public class Results
    {


        private IWebDriver driver;
        private List<Item> items = new List<Item>();
        public Item i;


        public Results(IWebDriver driver)
        {

            this.driver = driver;
            
        }

        public List<Item> GetResultBy(Dictionary<string,string> filters ) 
        {
            string xpLink = ".//*[@class='a-section a-spacing-small a-spacing-top-small']//descendant::a[@class='a-link-normal s-underline-text s-underline-link-text s-link-style a-text-normal']";
            string xpTitel = ".//*[@class='a-section a-spacing-none puis-padding-right-small s-title-instructions-style']//descendant::h2[@class='a-size-mini a-spacing-none a-color-base s-line-clamp-2']";
            string xpPrice = ".//span[@class='a-price' and translate(descendant::span[@class='a-offscreen']//.,'$','')]"; ;
             //   "//*[@class ='a-price']//descendant::span[@class = 'a-offscreen'][1]";
            string xp = "//div[@class ='a-section'";
            foreach (KeyValuePair<string, string> filter in filters)
            {

                switch(filter.Key) 
                {
                    case "price_low_then":
                        string price = filters["price_low_then"];
                        //float p= float.Parse(price);
                        xp += string.Format("and translate(descendant::span[@class = 'a-offscreen']//.,'$', '') < {0} ", price);

                        break;
                    case "price_higer_or_equal":
                        string price1 = filters["price_higer_or_equal"];
                        //float p1 = float.Parse(price1);
                        xp += string.Format("and translate(descendant::span[@class = 'a-offscreen']//.,'$', '')>={0} ] ",price1);
                        break;

                    case "free_shipping":
                        xp += "and descendant::span[@class='a-color-base a-text-bold']//text() ='FREE Shipping '";
                        break;

                    default:
                        Console.WriteLine("no option like this");
                        break;

                }

            }
            xp += "]";
            var list = driver.FindElements(By.XPath(xp));
            foreach (var item in list) 
            {
                var itemTxt = item.Text;
                IWebElement elm, elm1, elm2;
                i = new Item(this.driver);
                elm = item.FindElement(By.XPath(xpTitel));
                i.Title = elm.Text;
                elm1 = item.FindElement(By.XPath(xpLink));
                i.Link = elm1.Text;
                elm2 = item.FindElement(By.XPath(xpPrice));
                i.Price = elm2.Text;
                i.Price = i.Price.Replace("\r\n", ".");
                items.Add(i);
                Console.WriteLine(i.Title + i.Link + i.Price);
                Console.WriteLine("------------");

            }
            
            return items;

        }


    }
}
