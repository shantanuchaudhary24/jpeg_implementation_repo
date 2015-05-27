import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;


public class CoolCoolEncoderDecoder {

	public static void main(String[] args) throws IOException {

		if(args.length!=2)
			return;

		if(args[1].charAt(0)=='1')
			encode(args[0]);
		else
			decode(args[0]);
	}
	
	public static void decode(String file) throws IOException
	{
		BufferedReader br=new BufferedReader(new FileReader(file));

		String Y=br.readLine();
		String Cb=br.readLine();
		String Cr=br.readLine();
		
		br.close();

		decodeHelper(Y);
		decodeHelper(Cb);
		decodeHelper(Cr);
	}
	
	public static void decodeHelper(String color)
	{
		String arr[]=color.split(",");
		
		for(int i=0;i<arr.length;i+=2)
		{
			int number=Integer.parseInt(arr[i]);
			int count=Integer.parseInt(arr[i+1]);
			
			for(int j=0;j<count;j++)
			{
				System.out.print(number+(i+2==arr.length&&j+1==count?"":","));
			}
		}
		System.out.print("_");
	}
	
	public static void encode(String file) throws IOException
	{
		BufferedReader br=new BufferedReader(new FileReader(file));

		String Y=br.readLine();
		String Cb=br.readLine();
		String Cr=br.readLine();
		
		br.close();
		
		FileWriter fw=new FileWriter(file);
		
		fw.write(encodeHelper(Y)+"\n");
		fw.append(encodeHelper(Cb)+"\n");
		fw.append(encodeHelper(Cr)+"\n");
		
		fw.close();
	}

	public static String encodeHelper(String color)
	{
		String arr[]=color.split(",");

		String out="";
		boolean runOn=false;
		int runCount=0;
		int runNum=0;
		
		for(int i=0;i<arr.length;i++)
		{
			int thisNum=Integer.parseInt(arr[i]);
			
			if(runOn)
			{
				if(thisNum==runNum)
				{
					runCount++;
				}
				else
				{
					out+=(","+runCount+","+thisNum);
					runCount=1;
					runNum=thisNum;
				}
			}
			else
			{
				out+=(""+thisNum);
				runCount=1;
				runNum=thisNum;
				
				runOn=true;
			}
		}
		out+=(","+runCount);
		
		return out;
	}
}
