// Initialize Office.js
Office.onReady((info) => {
  console.log('Office.js is ready!');
  console.log('Host:', info.host);
  console.log('Platform:', info.platform);

  if (info.host === Office.HostType.Excel) {
    document.getElementById('run')?.addEventListener('click', run);
    console.log('Excel Add-in initialized successfully');
  } else {
    console.log('This add-in is designed for Excel');
    document.getElementById('result')!.innerHTML =
      '<p style="color: orange;">This add-in is designed for Excel. Please open in Excel to use all features.</p>';
  }
});

async function run() {
  try {
    console.log('Running Excel function...');

    await Excel.run(async (context) => {
      const range = context.workbook.getSelectedRange();
      range.format.fill.color = 'yellow';
      range.values = [['Hello from TypeScript Excel Add-in!']];
      await context.sync();
    });

    document.getElementById('result')!.innerHTML =
      '<p style="color: green;">✅ Excel function executed successfully!</p>';
  } catch (error) {
    console.error('Error:', error);
    const errorMessage = error instanceof Error ? error.message : String(error);
    document.getElementById('result')!.innerHTML =
      `<p style="color: red;">❌ Error: ${errorMessage}</p>`;
  }
}
