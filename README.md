# Movie Dataset Downloader
<h6>Personal project written on VS Code and run on linux (CentOS7)</h6>

<h2><dataset-downloader></h2>
  <p><b>dataset-downloader</b> as his name, it is a simple dataset downloader based on unix eviroment
  It automates the downloads of movies related data from the <i>Korean Film Counsil</i> (kobis.or.kr)
  This program downloads 2 type of dataset:
  <ol><li> Daily box office dataset </li>
    <li> Detailed movie info dataset (Movies those are included at the daily box office dataset) </li>
  </ol></p>
 
 <h3><Dev enviroment></h3>
  Bash file written on <b>VS Code</b>
  <b>Linux</b> terminal(CentOS7)
  <b>.JQ</b> line editor for Json files

<h4>Instruccions</h4>
<ul>
  *REQUISITE: <b>MUST</b> have all permission granted to <i>read/write/run</i> (rwx)
  <li> Open your terminal on Linux </li>
  <li> Go to your preferred workspace and create a new directory called '<b>movies_data</b>'</li>
  <code>MKDIR -pv /{$WORKSPACE PATH}/movies_data</code>
  <li> download the current latest version: <a href='https://raw.githubusercontent.com/filoscoder/movie_data_analisys/master/dataset-downloader-1.2.sh'>dataset-downloader-1.2.sh</a></li>

  
  <h4>Change Log</h4>
<ul>
  <strong><b># v1.2 <b/></strong>
  <li> Added .jq editor installer (if not yet installed) </li>
  <li> Fixed minor issues </li>
  <strong><b># v1.1 <b/></strong>
    <li> Changed the download path and the downloaded filenames to 'YYYYMMDD' </li>
    <li> Handled wrong user input format </li>
    <li> Fixed unnecessary downloads about existing files </li>
  <strong># v1.0 <b/></strong>
    <li> Initial release </li>
</ul>
