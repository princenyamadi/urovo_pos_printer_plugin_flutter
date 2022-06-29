// public class FontStylePanel{
//     private static final String FONT_NAME  = "font-name";
//     private static final String FONT_SIZE  = "font-size";
//     private static final String FONT_STYLE = "font-style";

//     private static final int FONT_STYLE_NULL      = 0x0000;
//     private static final int FONT_STYLE_BOLD      = 0x0001;
//     private static final int FONT_STYLE_ITALIC    = 0x0002;
//     private static final int FONT_STYLE_UNDERLINE = 0x0004;
//     private static final int FONT_STYLE_REVERSE   = 0x0008;
//     private static final int FONT_STYLE_STRIKEOUT = 0x0010; 
//     private String mFontName = "simsun";
//     private int mFontSize = 24;
//     private boolean isTextBold = false;
//     private boolean isTextItalic = false;
//     private boolean isTextUnderline = false;
//     private boolean isTextStrikeout = false;
//     private int mFontStyle = FONT_STYLE_NULL;

//     private String[] mFontNames;
//     private String[] mFontSizes;


//     public Bundle getFontInfo(){
//         mFontStyle = FONT_STYLE_NULL;
//         if(isTextBold){
//             mFontStyle |= FONT_STYLE_BOLD; 
//         }
//         if(isTextItalic){
//             mFontStyle |= FONT_STYLE_ITALIC;
//         }
//         if (isTextUnderline) {
//             mFontStyle |= FONT_STYLE_UNDERLINE;
//         }
//         if (isTextStrikeout) {
//             mFontStyle |= FONT_STYLE_STRIKEOUT;
//         }

//         Bundle fontInfo = new Bundle();
//         fontInfo.putString(FONT_NAME, mFontName);
//         fontInfo.putInt(FONT_SIZE, mFontSize);
//         fontInfo.putInt(FONT_STYLE, mFontStyle);

//         return fontInfo;
//     }
// }