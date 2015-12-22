//
//  ViewController.m
//  XMLParseDemo
//
//  Created by qingyun on 15/12/18.
//  Copyright © 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "QYBook.h"
#import "GDataXMLNode.h"

@interface ViewController () <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *books;
@property (nonatomic, strong) QYBook *currentBook;
@property (nonatomic, strong) NSString *content;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)xmlParse:(id)sender {
    //创建XML解析对象
    NSURL *xmlURL = [[NSBundle mainBundle] URLForResource:@"bookstore" withExtension:@"xml"];
    
    //1.creat
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    //2.设置XML解析对象的代理
    xmlParser.delegate = self;
    //3. 开始解析
    BOOL flag = [xmlParser parse];
    if (!flag) {
        NSLog(@"xmlParser parser error.");
    }
}

#pragma mark -NSXMLParserDelegate
//当开始解析XML文档的时候，调用这个方法。通常在这个方法里，创建存储模型对象的数组
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"解析开始。。。");
    _books = [NSMutableArray array];
}

//当开始解析，遇到元素的开始标签的时候，调用这个方法。通常在这个方法里，创建模型对象或解析标签中的属性保存在模型对象中
- (void)parser:(NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ([elementName isEqualToString:kBook]) {
        _currentBook = [[QYBook alloc] init];
        //取出book标签中的属性
        _currentBook.category = attributeDict[kCategory];
    }else if ([elementName isEqualToString:kTitle]){
        //取出title标签中的属性
        _currentBook.lang = attributeDict[kLanguage];
    }else{
        //do nothing
    }
}

//当解析到XML标签的文本内容的时候，调用这个方法，通常在这里先暂存解析到的文本内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(nonnull NSString *)string
{
    _content = string;
}

//当解析XML内容遇到结束标签的时候，调用这个方法。通常在这个方法里，需要将模型对象保存入数组中或把标签对应的文本内容解析出来，保存在模型对象中（KVC）
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kBookStore]) {
        NSLog(@"解析即将结束！");
    }else if ([elementName isEqualToString:kBook]){
        [_books addObject:_currentBook];
    }else{
        [_currentBook setValue:_content forKey:elementName];
    }
}

//当整个XML文档全部解析结束的时候，该方法会被调用
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"解析完成！");
    NSLog(@"%@",_books);
}

//当遇到解析错误时，该方法会被调用
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@",parseError);
}

- (IBAction)domParse:(id)sender {
    
    //根据XML文件创建NSData对象
    NSURL *xmlURL = [[NSBundle mainBundle] URLForResource:@"bookstore" withExtension:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfURL:xmlURL];
    
    //根据NSData对象创建GDataXMLDocument对象（即DOM模型对象），该对象在内存中是以树形结构存储的
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    //通过DOM模型对象，取出XML文件的根元素
    GDataXMLElement *rootElement = [doc rootElement];
    
    NSArray *booksElement = [rootElement elementsForName:kBook];
    _books = [NSMutableArray array];
    //由于是树形结构，所以，可以根据子元素的名字使用根元素获取到所有子元素，并类推获得子元素的子元素
    for (GDataXMLElement *bookElement in booksElement) {
        QYBook *book = [[QYBook alloc] init];
        book.category = [[bookElement attributeForName:kCategory] stringValue];
        
        //title element
        GDataXMLElement *titleElement = [bookElement elementsForName:kTitle][0];
        book.title = [titleElement stringValue];
        book.lang = [[titleElement attributeForName:kLanguage] stringValue];
        
        //author
        GDataXMLElement *authorElement = [bookElement elementsForName:kAuthor][0];
        book.author = [authorElement stringValue];
        
        //year
        GDataXMLElement *yearElement = [bookElement elementsForName:kYear][0];
        book.year = [yearElement stringValue];
        
        //price
        GDataXMLElement *priceElement = [bookElement elementsForName:kPrice][0];
        book.price = [priceElement stringValue];
        
        [_books addObject:book];
    }
    NSLog(@"%@",_books);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
