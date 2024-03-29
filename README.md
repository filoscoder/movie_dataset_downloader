# Movie Dataset Downloader
<h6>Personal project written on VS Code and run on linux (CentOS7)</h6>

<h2>| dataset-downloader |</h2>
  <p><b>dataset-downloader</b> as his name, it is a simple dataset downloader based on unix eviroment
  It automates the downloads of movies related data from the <i>Korean Film Counsil</i> (kobis.or.kr)
  This program downloads 2 type of dataset:
  <ol><li> Daily box office dataset </li>
    <li> Detailed movie info dataset (Movies those are included at the daily box office dataset) </li>
  </ol></p>
  
 <h3>| Dev enviroment |</h3>
  Bash file written on <b>VS Code</b>(Windows)
  <b>Linux</b> terminal(CentOS7)
  <b>.JQ</b> line editor for Json files
<br/>
<h3>| Instructions |</h3>
<ul>
  *REQUISITE: <b>MUST</b> have all permission granted to <i>read/write/run</i> (rwx)
  <li> Open your terminal on Linux </li>
  <li> Go to your preferred workspace and create a new directory called '<b>movies_data</b>'</li>
  <code>MKDIR -pv /{$WORKSPACE PATH}/movies_data</code>
  <li> Web download ('wget' command) the current latest version inside '<b>movies_data</b>': <a href='https://github.com/filoscoder/movie_dataset_downloader/releases/download/v1.3/dataset-downloader-1.3.sh'>dataset-downloader-1.3.sh</a></li>
  <code>wget -p /{$WORKSPACE PATH}/ https://github.com/filoscoder/movie_dataset_downloader/releases/download/v1.3/dataset-downloader-1.3.sh </code>
  <li>Grant full access to the downloader file</li>
  <code>chmod 777 dataset-downloader-1.3.sh </code>
  <li>Run the file and Enjoy!</li>
  <code> ./dataset-downloader-1.3.sh </code>
  <br/>
  <li><em>Please don't rename the folders that contains the datasets (otherwise it will be created again)
  <li><em>If you experience some syntax issues try again after this</em></li>
  <code> sed -i 's/\r$//g' /home/hadoop/movies_data/dataset-downloader-1.3.sh</code>
  <br/><i>this issue is well known for bash files written on windows. Linux understand the windows 'Enter' key like '\r' (carriage return) so the code above use the stream line editor to remove every '\r' on the file.</i>
  <br/><li><em>If you keep have troubles running the downloader, please send me an email (sondaniel.88@gmail.com) </em></li>

  <br/>
  <h3>| Change Log |</h3>
<ul>
  <h5><strong># v1.3 </strong></h5>
  <li> Download path setted on the current working directory </li>
  <li> Fixed some minor issues </li>
    
  <h5><strong># v1.2 </strong></h5>
  <li> Added .jq editor installer (if not yet installed) </li>
  <li> Fixed minor issues </li>
  
  <h5><strong># v1.1 </strong></h5>
    <li> Changed the download path and the downloaded filenames to 'YYYYMMDD' </li>
    <li> Handled wrong user input format </li>
    <li> Fixed unnecessary downloads about existing files </li>
  
  <h5><strong># v1.0 </strong><h5>
    <li> Initial release </li>
</ul>
<br/><br/><br/>
<div align='center'><p>*********Feel free to fork, contribute, make constructive comments *********</p></div>

<div align='right'><p>Credits <a href="https://github.com/filoscoder/">Filoscoder&copy;</a></p></div>
