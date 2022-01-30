namespace DAppHeroesNFT.Models;
public class ConnectHelp
{
    public ConnectHelp()
    {
        this.AccountConnected = "";
    }
    public string AccountConnected;
    public bool Connected => this.AccountConnected != "" && this.AccountConnected != null;

}