namespace DAppHeroesNFT.Models;

public class HeroNFT
{
    public HeroNFT()
    {
    }
    public HeroNFT(string name, string urlImg)
    {
        this.Name = name;
        this.UrlImg = urlImg;
    }

    public int Id { get; set; }
    public string Name { get; set; }
    public string Class { get; set; }
    public int Level { get; set; }
    public string UrlImg { get; set; }
}